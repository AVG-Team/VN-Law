package Controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import models.Indexvbqppl;
import models.Vbqppl;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import repositories.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

public class SplitDocumentController {

    EntityTransaction transaction = null;
    EntityManager entityManager = null;

    private List<Indexvbqppl> index = new ArrayList<>();

    public List<Vbqppl> getData() {


        entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
        transaction = entityManager.getTransaction();
        transaction.begin();

        // Thực hiện truy vấn JPA để lấy dữ liệu từ cơ sở dữ liệu
        TypedQuery<Vbqppl> query = entityManager.createQuery("SELECT v FROM Vbqppl v", Vbqppl.class);
        List<Vbqppl> result = query.getResultList();
        // Kết thúc transaction
        entityManager.getTransaction().commit();

        // Đóng EntityManager
        entityManager.close();

        return result;
    }

    public Indexvbqppl setInstance(int id, String idVbqppl, int idChapter, String text){
        Indexvbqppl index = new Indexvbqppl();
        index.setId(id);
        index.setIdVbqppl(idVbqppl);
        index.setContent(text);
        index.setIndexParent(idChapter);
        index.setName("");
        return  index;
    }

    public void Change(String text, int old , int news,int id, String idVbqppl, int idChapter){
        if(old == 1 && news == 2){
            index.add(setInstance(id,idVbqppl,-1,text));
        }
        if(old == 2){
            index.add(setInstance(id,idVbqppl,idChapter,text));
        }
    }

    public void splitDocument() {
        int id = 3012;
        int idChapter = 0;
        int flag = 0;
        int i = 0;

        List<Vbqppl> data = getData();

        for (Vbqppl item : data) {
            String idVqppl = item.getId();
            String url = "https://vbpl.vn/TW/Pages/vbpq-toanvan.aspx?ItemID=" + idVqppl;

            try {
                Element document = getDocument(url);
                if (document != null) {
                    List<String> paragraphs = new ArrayList<>();
                    Elements paragraphElements = document.select("p");

                    for (Element element : paragraphElements) {
                        String paragraph = element.text().replace("\n", "").trim();
                        paragraphs.add(paragraph);
                    }

                    boolean isNewChapter = false;
                    StringBuilder text = new StringBuilder();

                    for (String itemPara : paragraphs) {
                        if (itemPara.startsWith("Chương") || itemPara.startsWith("CHƯƠNG")) {
                            if (isNewChapter) {
                                Change(text.toString(), flag, 1, id, idVqppl, -1);
                                text.setLength(0); // Reset StringBuilder
                            }
                            id += 1;
                            idChapter = id + 1;
                            flag = 1;
                            isNewChapter = true;
                        } else if (itemPara.startsWith("Đi")) {
                            if (isNewChapter) {
                                Change(text.toString(), flag, 2, id, idVqppl, idChapter);
                                text.setLength(0); // Reset StringBuilder
                            }
                            id += 1;
                            flag = 2;
                            isNewChapter = false;
                        }
                        text.append(itemPara).append("\n");
                    }

                    // Call Change() for the last paragraph block
                    Change(text.toString(), flag, 2, id, idVqppl, idChapter);
                }

                System.out.println("Load : " + i++);
            } catch (Exception e) {
                e.printStackTrace();
                continue;
            }
        }

        saveData(index);
        System.out.println("Complete");
    }


    public Element getDocument(String url){
        try{
            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpGet request = new HttpGet(url);
                CloseableHttpResponse response = httpClient.execute(request);

                try {
                    // Kiểm tra mã trạng thái của phản hồi
                    int statusCode = response.getStatusLine().getStatusCode();
                    if (statusCode == 200) {
                        // Đọc nội dung của phản hồi
                        String htmlContent = EntityUtils.toString(response.getEntity());

                        // Phân tích HTML bằng JSoup
                        Document document = Jsoup.parse(htmlContent);

                        // Tìm các thẻ div có class là 'fulltext'
                        Elements divTexts = document.select("div.fulltext");
                        if (!divTexts.isEmpty()) {
                            // Lấy phần tử div thứ nhất (index 0 là div fulltext)
                            Element divText = divTexts.get(0);

                            // Lấy phần tử div thứ hai bên trong div fulltext
                            Element contentHtml = divText.select("div").get(2);
                            return contentHtml.getElementById("toanvancontent");
                        }
                    }
                } finally {
                    response.close();
                }
            }
        }catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public void saveData(List<Indexvbqppl> objects) {
        EntityManager entityManager = null;
        EntityTransaction transaction = null;
        int i = 0;
        try {
            entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
            transaction = entityManager.getTransaction();
            transaction.begin();

            for (Indexvbqppl item : objects) {
                Indexvbqppl indexvbqppl = entityManager.find(Indexvbqppl.class, item.getId());
                if (indexvbqppl == null) {
                    entityManager.persist(item);
                    System.out.println("Save : " + i++);
                }
            }

            transaction.commit();
            System.out.println("Inserted completely");
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (entityManager != null && entityManager.isOpen()) {
                entityManager.close();
            }
        }
    }
}

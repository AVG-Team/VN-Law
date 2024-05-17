package Controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import models.*;
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

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class CrawlDocumentController {

    private final String regex = "\\bItemID=(\\d+)\\b";
    EntityTransaction transaction = null;
    EntityManager entityManager = null;

    public void crawlDocument() {

        List<String> data = getData();
        System.out.println(data.size());

        List<String> list = data.stream()
                .filter(Objects::nonNull)
                .map(this::getInfo)
                .collect(Collectors.toList());

        List<String> unique = list.stream()
                .distinct()
                .collect(Collectors.toList());
        System.out.println(unique.size());

        List<String> ids = new ArrayList<>();
        List<String> contents = new ArrayList<>();
        int count = 0;
        for(String item : unique){

            String id = item;
            String urlContent = "https://vbpl.vn/TW/Pages/vbpq-toanvan.aspx?ItemID="+id;
            try{
                try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                    HttpGet request = new HttpGet(urlContent);
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
                                String content = contentHtml.toString();
                                System.out.println(content);

                                   ids.add(id);
                                   contents.add(content);
                            }
                        }
                    } finally {
                        response.close();
                    }
                }
            }catch (Exception ex){
                continue;
            }
            if(count % 10 == 0){
                saveData(ids,contents);
                System.out.println("sss");
                ids.clear();
                contents.clear();
            }
            count += 1;
            System.out.println(count);
        }
        saveData(ids,contents);
        System.out.println("successfully");
    }

    public List<String> getData() {
        entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();

        transaction = entityManager.getTransaction();
        transaction.begin();

        // Thực hiện truy vấn JPA để lấy dữ liệu từ cơ sở dữ liệu
        TypedQuery<String> query = entityManager.createQuery("SELECT a.vbqpplLink FROM Pdarticle a", String.class);
        List<String> result = query.getResultList();
        // Kết thúc transaction
        entityManager.getTransaction().commit();

        // Đóng EntityManager
        entityManager.close();

        return result;
    }

    public String getInfo(String url) {
        if (url == null)
            return null;
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(url);
        if (matcher.find()) {
            return matcher.group(1);
        } else {
            return "Not Found!!";
        }
    }

    public void saveData(List<String> ids, List<String> contents) {
        try {
            entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
            transaction = entityManager.getTransaction();
            transaction.begin();
            for(int i = 0 ; i < ids.size() ; i++){
                Vbqppl vbqppl = new Vbqppl();
                vbqppl.setId(ids.get(i));
                vbqppl.setContent(contents.get(i));

               Vbqppl vbqppl1 = entityManager.find(Vbqppl.class, vbqppl.getId());
                if(vbqppl1 == null){
                    entityManager.persist(vbqppl);
                }
            }
            transaction.commit();
            /* System.out.println("Inserted completely");*/
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

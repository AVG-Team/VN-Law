package Controller;


import com.google.gson.*;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import model.*;
import Helper.Helpers;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import Repository.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Crawler {

    public final Helpers helper;

    public Crawler(Helpers helper) {
        this.helper = helper;
    }

    public JsonArray loadData(String filePath) throws IOException {
        System.out.println("Load Topic from File Json...");

        JsonArray jsonArray = helper.readJsonFile(filePath);

      /*  if(jsonArray != null){
            System.out.println("Result: " + jsonArray.toString());
        }else{
            System.out.println("Not exist");
        }*/

        return jsonArray;
    }


    public List<String> loadDataFromFile(String filePath) throws IOException {

        List<String> relationArticle = new ArrayList<String>();
        Files.walk(Paths.get(filePath))
                .filter(Files::isRegularFile)
                .forEach(file -> {
                    try {
                        String content = new String(Files.readAllBytes(file));

                        relationArticle.add(content);
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                });
        return relationArticle;
    }

    public ArrayList<HashMap<String, String>> insertElements(String subjectDirectory,String treeNode) throws IOException {

        // prepare variable

        String checkpoint = "d8e4a3a0-254c-4593-967c-214ae12bcb0f.html";
        boolean isSkipping;
        int count = 0;
        File folder = new File(subjectDirectory);
        File[] listOfFiles = folder.listFiles();

        JsonArray subjectNode = new JsonArray();
        JsonArray chapterNode = new JsonArray();
        JsonArray articleNode = new JsonArray();
        JsonArray lateralNode = new JsonArray();


        JsonArray nodes = loadData(treeNode);
        List<Pdchapter> chaptersData = new ArrayList<>();
        List<Pdsubject> pdsubjects = getData();
        isSkipping = true;


        ArrayList<HashMap<String, String>> relationsMap = new ArrayList<>();
        String chapterId = "";
        String subjectId = "";
        for (File file : listOfFiles) {

            String fileName = file.getName();

            System.out.println(fileName);

            count++;
            /*if (fileName.equals(checkpoint)) {
                isSkipping = false;
            }
            if (isSkipping) continue;
*/

            // danh sach demuc
            Document subjectHtml = Jsoup.parse(file, "UTF-8");


            for (JsonElement element : nodes) {
                JsonObject object = element.getAsJsonObject();
                subjectId = object.getAsJsonPrimitive("DeMucID").getAsString();
                if (subjectId.equals(fileName.split("\\.")[0])) {

                    subjectNode.add(object);
                }
            }


            // danh sach chuongg
            for (JsonElement element : subjectNode) {
                JsonObject object = element.getAsJsonObject();
                JsonElement nameElement = object.get("TEN");

                if (nameElement != null && nameElement.isJsonPrimitive()) {
                    String name = nameElement.getAsString();
                    if (name.startsWith("Chương ") ) {
                        chapterNode.add(object);
                    }
                    if(name.startsWith("Phần ")){
                        chapterNode.add(object);
                    }
                }
            }


            int order = 10;
            for (JsonElement element : chapterNode) {
                if (element instanceof JsonObject) {
                    JsonObject chapter = (JsonObject) element;

                    String idChapter = chapter.get("MAPC").getAsString();

                    Pdchapter chapterData = new Pdchapter();
                    chapterData.setName(chapter.get("TEN").getAsString());
                    chapterData.setId(idChapter);
                    chapterData.setIndex(chapter.get("ChiMuc").getAsString());
                    if(chapter.get("TEN").getAsString().startsWith("Phần ")) {
                        chapterData.setOrder(order);
                        order+=10;
                    }else{
                        int orderChapter = helper.ConvertRomanToNum(chapter.get("ChiMuc").getAsString());
                        chapterData.setOrder(orderChapter);
                    }
                    chapterData.setIdSubject(chapter.get("DeMucID").getAsString());

                    try {
                      insertData(chapterData);
                       /* System.out.println("Insert Chapter Completed");*/
                    } catch (Exception e) {
                        System.out.println("chapter failed");
                        e.printStackTrace();
                        continue;
                    }

                    chaptersData.add(chapterData);
                }

            }
            order = 10;



            // Trường hợp nếu chapter rỗng
            if (chaptersData.isEmpty()) {
                UUID idTemp = UUID.randomUUID();
                Pdchapter pdchapter = new Pdchapter();
                pdchapter.setId(idTemp.toString());
                pdchapter.setName("");
                pdchapter.setIndex("0");
                pdchapter.setOrder(0);
                pdchapter.setIdSubject(fileName.split("//.")[0]);
                chaptersData.add(pdchapter);
            }


            for (JsonElement element : subjectNode) {
                if (element instanceof JsonObject) {
                    if (!chapterNode.contains(element) && !lateralNode.contains(element)) {
                        JsonObject object = (JsonObject) element;
                        articleNode.add(object);
                    }
                }
            }



            /*for(JsonElement s : articleNode){
                System.out.println(s.toString());
            }*/



            for (JsonElement element : articleNode) {
                JsonObject article = element.getAsJsonObject();

                if (chaptersData.size() == 1) {
                    String chuongId = chaptersData.get(0).getId();
                    article.addProperty("ChuongID", chuongId);
                } else {
                    for (Pdchapter chapter : chaptersData) {
                        if (article.get("MAPC").getAsString().startsWith(chapter.getId())) {
                            article.addProperty("ChuongID", chapter.getId());
                            break;
                        }
                    }

                }

                // variable
                String lawText = "";
                String lawLink = "";

                String articleID = article.get("MAPC").getAsString();
                Element articleHtml = subjectHtml.select(String.format("a[name='%s']", articleID)).first();
                List<Element> contentHtml = new ArrayList<>();
                List<Element> filesHtml = new ArrayList<>();
                if (articleHtml != null) {
                    String articleName = articleHtml.nextSibling().outerHtml();
                    Element noteHtml = articleHtml.parent().nextElementSibling();

                    if (noteHtml != null) {
                        lawText = noteHtml.text();
                        lawLink = null;
                        Elements links = noteHtml.select("a");
                        if (!links.isEmpty()) {
                            lawLink = links.first().attr("href");
                        }
                        // content
                        Element content = articleHtml.parent().nextElementSibling();
                        if (content != null) {
                            content = content.nextElementSibling();
                            if (content != null) {
                                content = content.nextElementSibling();
                                if (content != null) {
                                    // Now content should not be null, you can safely use it.
                                    while (content != null && (!content.text().isEmpty() || content.tagName().equals("div"))) {
                                        if (!content.hasClass("pGhiChu") && !content.hasClass("pDieu") && !content.hasClass("pChuong")
                                                && !content.hasClass("pNoiDung")) {
                                            contentHtml.add(content);

                                        }
                                        if (content.text().isEmpty()) {
                                            break;
                                        }
                                        content = content.nextElementSibling();
                                    }
                                }
                            }
                        }

                        Element fileContent = articleHtml.parent().nextElementSibling();
                        if (fileContent != null) {
                            fileContent = fileContent.nextElementSibling();
                            if (fileContent != null) {
                                fileContent = fileContent.nextElementSibling();
                                if (fileContent != null) {
                                    while (fileContent != null) {
                                        if (fileContent.tagName().equals("a")) {
                                            filesHtml.add(fileContent);
                                        }
                                        if (fileContent.hasClass("pDieu")) break;
                                        fileContent = fileContent.nextElementSibling();
                                    }
                                }
                            }
                        }

                        StringBuilder contentString = new StringBuilder();
                        List<String> tables = new ArrayList<>();
                        for (Element contentItem : contentHtml) {
                            if (contentItem.tagName().equals("table")) {
                                tables.add(contentItem.toString());
                                continue;
                            }
                            contentString.append(contentItem.text().trim()).append("\n");
                        }

                        try {
                            Pdarticle pdarticle = new Pdarticle();
                            pdarticle.setId(articleID);
                            pdarticle.setName(articleName);
                            pdarticle.setIndex(article.get("ChiMuc").getAsString());
                            pdarticle.setContent(contentString.toString());
                            pdarticle.setVbqppl(lawText);
                            pdarticle.setVbqpplLink(lawLink);
                            if(article.get("ChuongID") == null){
                                pdarticle.setIdChapter(article.get("PhanID").getAsString());
                            }else{
                                pdarticle.setIdChapter(article.get("ChuongID").getAsString());
                            }
                            pdarticle.setIdSubject(article.get("DeMucID").getAsString());
                            pdarticle.setIdTopic(article.get("ChuDeID").getAsString());
                            pdarticle.setOrder(order);

                             insertData(pdarticle);
                        } catch (Exception e) {
                          e.printStackTrace();
                            System.out.println("article failed");
                            continue;
                        }

                        for (String table : tables) {
                            Pdtable pdtable = new Pdtable();
                            pdtable.setIdArticle(articleID);
                            pdtable.setHtml(table);
                           /* System.out.println(table);*/
                            insertData(pdtable);
                            /*System.out.println("Insert Table Completed");*/
                        }


                        String linksFile = "";
                        for (Element item : filesHtml) {
                            if (item.tagName().equals("a")) {
                                linksFile = item.attr("href");

                                try {
                                    Pdfile pdfile = new Pdfile();
                                    pdfile.setLink(linksFile);
                                    pdfile.setIdArticle(article.get("MAPC").getAsString());
                                    pdfile.setPath("");
                                    /*System.out.println(item.toString());*/
                                    insertData(pdfile);
                                    /*System.out.println("Insert File Completed");*/
                                } catch (Exception ex) {
                                    System.out.println("Insert File Failed");
                                    ex.printStackTrace();
                                    continue;
                                }
                            }
                            Element fileLink = item.nextElementSibling();

                            if(fileLink == null) continue;

                            if (fileLink.tagName().equals("p") && fileLink.hasClass("pChiDan")) {
                                   Elements relationHtml = fileLink.select("a");

                                   /*  System.out.println(relationHtml.toString());*/
                                   if (!relationHtml.hasAttr("onclick") || relationHtml.attr("onclick").isEmpty()) {
                                       continue;
                                   }
                                   String idRelation = helper.extractInput(relationHtml.attr("onclick").replace("'", ""));
                                   relationsMap.add(new HashMap<String, String>() {{
                                       put("idRelation1", article.get("MAPC").getAsString());
                                       put("idRelation2", idRelation);
                                   }});

                            }

                        }

                        order++;
                    } else {
                        System.out.println("Not Founded");
                    }
                }
            }
            System.out.println(count);
            System.out.println("complete");
        }


        System.out.println("complete");
        return relationsMap;
    }

    public void insertRelationTable(ArrayList<HashMap<String, String>> relationsMap){
        for (HashMap<String, String> item : relationsMap) {
            try {
                Pdrelation pdrelation = new Pdrelation();
                pdrelation.setIdArticle1(item.get("idRelation1"));
                pdrelation.setIdArticle2(item.get("idRelation2"));
                insertData(pdrelation);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("Không thể insert liên quan " + item.get("idRelation1") + " - " + item.get("idRelation2"));
            }
        }
    }

    public void insertData(JsonArray jsonArray, Object object) {
        EntityTransaction transaction = null;
        EntityManager entityManager = null;

        try {
            entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
            transaction = entityManager.getTransaction();
            transaction.begin();

            for (JsonElement jsonElement : jsonArray) {
                JsonObject jsonObject = jsonElement.getAsJsonObject();

                if (jsonObject != null) {
                    String id = jsonObject.getAsJsonPrimitive("Value").getAsString();

                    if (object instanceof Pdtopic) {
                        Pdtopic pdtopic = entityManager.find(Pdtopic.class, id);
                        if (pdtopic == null) {
                            pdtopic = new Pdtopic();
                            pdtopic.setId(id);
                            pdtopic.setName(jsonObject.getAsJsonPrimitive("Text").getAsString());
                            pdtopic.setOrder(jsonObject.getAsJsonPrimitive("STT").getAsInt());
                            entityManager.persist(pdtopic);
                        }
                    } else if (object instanceof Pdsubject) {
                        Pdsubject pdsubject = entityManager.find(Pdsubject.class, id);
                        if (pdsubject == null) {
                            pdsubject = new Pdsubject();
                            pdsubject.setId(id);
                            pdsubject.setName(jsonObject.getAsJsonPrimitive("Text").getAsString());
                            pdsubject.setOrder(jsonObject.getAsJsonPrimitive("STT").getAsInt());
                            pdsubject.setIdTopic(jsonObject.getAsJsonPrimitive("ChuDe").getAsString());
                            entityManager.persist(pdsubject);
                        }
                    } else if (object instanceof Pdchapter) {
                        Pdchapter pdchapter = entityManager.find(Pdchapter.class, id);
                        if (pdchapter == null) {
                            entityManager.persist(object);
                        }
                    }
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

    public void insertData(Object object) {

        EntityTransaction transaction = null;
        EntityManager entityManager = null;

        try {
            entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
            transaction = entityManager.getTransaction();
            transaction.begin();

            if (object instanceof Pdchapter) {
                Pdchapter pdchapter = entityManager.find(Pdchapter.class, ((Pdchapter) object).getId());
                if (pdchapter == null) {
                    entityManager.persist(object);

                }
            }
            if (object instanceof Pdarticle) {
                Pdarticle pdarticle = entityManager.find(Pdarticle.class, ((Pdarticle) object).getId());
                if (pdarticle == null) {
                    entityManager.persist(object);

                }
            }
            if (object instanceof Pdfile) {
                Pdfile pdfile = entityManager.find(Pdfile.class, ((Pdfile) object).getId());
                if (pdfile == null) {
                    entityManager.persist(object);

                }
            }
            if (object instanceof Pdtable) {
                Pdtable pdtable = entityManager.find(Pdtable.class, ((Pdtable) object).getId());
                if (pdtable == null) {
                    entityManager.persist(object);

                }
            }
            if (object instanceof Pdrelation) {
                Pdrelation pdrelation = entityManager.find(Pdrelation.class, ((Pdrelation) object).getIdArticle1());
                if(pdrelation == null){
                    entityManager.persist(object);

                }
            }

            transaction.commit();
           /* System.out.println("Inserted completely");*/
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            System.out.println(object.toString());
        } finally {
            if (entityManager != null && entityManager.isOpen()) {
                entityManager.close();
            }
        }
    }

    public List<Pdsubject> getData() {

        EntityTransaction transaction = null;
        EntityManager entityManager = null;


        entityManager = HibernateUtil.getEntityManagerFactory().createEntityManager();
        transaction = entityManager.getTransaction();
        transaction.begin();



        // Thực hiện truy vấn JPA để lấy dữ liệu từ cơ sở dữ liệu
        List<Pdsubject> objects = entityManager.createQuery("SELECT e FROM Pdsubject e", Pdsubject.class).getResultList();


        // Kết thúc transaction
        entityManager.getTransaction().commit();

        // Đóng EntityManager
        entityManager.close();

        return objects;

    }
}

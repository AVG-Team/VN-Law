package Controller;


import com.google.gson.*;
import model.*;
import Helper.Helpers;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

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

    public void insertElements() throws IOException {

        // prepare variable
        String treeNode = "src/main/java/LawDirection/TreeNodes.json";
        String subjectDirectory = "src/main/java/LawDirection/test";
        String checkpoint = "d8e4a3a0-254c-4593-967c-214ae12bcb0f.html";
        boolean isSkipping = true;
        int count = 0;
        File folder = new File(subjectDirectory);
        File[] listOfFiles = folder.listFiles();

        JsonArray subjectNode = new JsonArray();
        JsonArray chapterNode = new JsonArray();
        JsonArray articleNode = new JsonArray();

        JsonArray nodes = loadData(treeNode);
        List<Pdchapter> chaptersData = new ArrayList<>();
        if (checkpoint != null) {
            isSkipping = true;
        } else {
            isSkipping = false;
        }

        for (File file : listOfFiles) {


            String fileName = file.getName();

           /* StringBuilder content = new StringBuilder();
            try(BufferedReader reader =  new BufferedReader(new FileReader(file.getPath()))) {

                count++;
                if(fileName.equals(checkpoint)){
                    isSkipping = false;
                }
                if(isSkipping) continue;




            } catch (IOException e) {
                throw new RuntimeException(e);
            } ;*/


            // danh sach demuc
            Document subjectHtml = Jsoup.parse(file, "UTF-8");


            for (JsonElement element : nodes) {
                JsonObject object = element.getAsJsonObject();
                String subjectId = object.getAsJsonPrimitive("DeMucID").getAsString();
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
                    if (name.startsWith("Chương ")) {
                        System.out.println(name);
                        chapterNode.add(object);
                    }
                }
            }


            for(JsonElement element : chapterNode){
                if(element instanceof  JsonObject){
                    JsonObject chapter = (JsonObject) element;

                    String idChapter = chapter.get("MAPC").getAsString();
                    int orderChapter = helper.ConvertRomanToNum(chapter.get("ChiMuc").getAsString());

                    Pdchapter chapterData = new Pdchapter();
                    chapterData.setName(chapter.get("TEN").getAsString());
                    chapterData.setId(idChapter);
                    chapterData.setIndex(chapter.get("ChiMuc").getAsString());
                    chapterData.setOrder(orderChapter);
                    chapterData.setIdSubject(chapter.get("DeMucID").getAsString());

                    try{
                        /*insertData(chapterData);*/
                    }catch (Exception e){
                        continue;
                    }

                    chaptersData.add(chapterData);
                }

            }

            // Trường hợp nếu chapter rỗng
            if(chaptersData.isEmpty()){
                UUID idTemp = UUID.randomUUID();
                Pdchapter pdchapter = new Pdchapter();
                pdchapter.setId(idTemp.toString());
                pdchapter.setName("");
                pdchapter.setIndex("0");
                pdchapter.setOrder(0);
                pdchapter.setIdSubject(fileName.split("//.")[0]);
                chaptersData.add(pdchapter);
            }

            for(JsonElement element : subjectNode){
                if(element instanceof  JsonObject){
                    if(!chapterNode.contains(element)){
                        JsonObject object = (JsonObject) element;
                        /*System.out.println(object.toString());*/
                        articleNode.add(object);
                    }
                }
            }

            int order = 0;

            /*for(JsonElement s : articleNode){
                System.out.println(s.toString());
            }*/

            for(JsonElement element : articleNode){
                JsonObject article = (JsonObject) element;
                if(chaptersData.size() == 1){
                    String chuongId =chaptersData.get(0).getId();
                    article.addProperty("ChuongID",chuongId);
                }else{
                    for(Pdchapter chapter : chaptersData){
                        JsonElement articleElement = article.get("ChuongID");
                        if(articleElement != null && articleElement.isJsonPrimitive()){
                            String chapterID = articleElement.getAsString();
                            if(chapterID.startsWith(chapter.getId())){
                                article.addProperty("ChuongID",chapter.getId());
                                break;
                            }
                        }
                    }
                }

                String articleID = article.get("MAPC").getAsString();
                Element articleHtml = subjectHtml.select(String.format("a[name='%s']",articleID)).first();
                if(articleHtml !=null){
                    String articleName = articleHtml.nextSibling().outerHtml();
//                    System.out.println(articleName);
                    Element noteHtml = articleHtml.parent().nextElementSibling();
                    String lawText = noteHtml != null ? noteHtml.text() : null;
                    String lawLink = null;
                    Elements links = noteHtml.select("a");
                    if(!links.isEmpty()){
                        lawLink = links.first().attr("href");
                    }
                    String contentArticle = null;
                    Element contentsHtml = articleHtml.parent().selectFirst("p.pNoiDung");
                    if(contentsHtml != null){
                        System.out.println(contentsHtml.text());
                    }



                }


                /*System.out.println(lawText);
                System.out.println(lawLink);*/

            }



        }

       /* System.out.println(subjectNode);
        System.out.println(chapterNode);
        for(Pdchapter item: chaptersData){
            System.out.println(item.getName());
        }*/

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
                    }else if ( object instanceof  Pdchapter){
                        Pdchapter pdchapter = entityManager.find(Pdchapter.class,id);
                        if(pdchapter == null){
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
                Pdchapter pdchapter = entityManager.find(Pdchapter.class,  ((Pdchapter) object).getId());
                if (pdchapter == null) {
                    entityManager.persist(object);
                }
            }
            transaction.commit();
            System.out.println("Inserted completely");
        }catch(Exception e) {
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

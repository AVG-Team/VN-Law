import Controller.CrawlController;
import Controller.CrawlDocumentController;
import Controller.SplitDocumentController;
import helpers.Helpers;
import models.Pdsubject;
import models.Pdtopic;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class CrawlApplication {
    public static String topicFile = "src/main/java/law_direction/Topics.json";
    public static String subjectFile = "src/main/java/law_direction/Subjects.json";
    public static String treeNode= "src/main/java/law_direction/TreeNodes.json";
    public static String subjectDirectory = "src/main/java/law_direction/SubjectDirectory";
    public static  String test = "src/main/java/law_direction/test";
    public static String fail = "src/main/java/law_direction/fail";
    public static String fail1 = "src/main/java/law_direction/fail1";

    public static String path1 = "src/main/java/law_direction/Part1";
    public static String path2 = "src/main/java/law_direction/Part2";
    public static String path3 = "src/main/java/law_direction/Part3";
    public static String path4 = "src/main/java/law_direction/Part4";
    public static String path5 = "src/main/java/law_direction/Part5";
    public static String path6 = "src/main/java/law_direction/Part6";
    public static String path7 = "src/main/java/law_direction/Part7";

    public static void main(String[] args) throws IOException {

//        Helpers helpers = new Helpers();
//        CrawlController crawler = new CrawlController(helpers);
//        Pdtopic pdtopic = new Pdtopic();
//        Pdsubject pdsubject = new Pdsubject();


      /* JsonArray topics= crawler.loadData(topicFile);
        crawler.insertData(topics,pdtopic);

        JsonArray subjects = crawler.loadData(subjectFile);
        crawler.insertData(subjects,pdsubject);*/
//        ArrayList<HashMap<String,String>> map = crawler.insertElements(test,treeNode);
//
//        crawler.insertRelationTable(map);

        CrawlDocumentController crawlDocumentController = new CrawlDocumentController();
        SplitDocumentController splitDocumentController = new SplitDocumentController();

        splitDocumentController.splitDocument();

    }
}

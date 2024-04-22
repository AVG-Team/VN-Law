import Controller.Crawler;
import Helper.Helpers;
import com.google.gson.JsonArray;
import model.Pdsubject;
import model.Pdtopic;

import java.io.IOException;
import java.util.ArrayList;

public class Main {
    public static String topicFile = "src/main/java/LawDirection/Topics.json";
    public static String subjectFile = "src/main/java/LawDirection/Subjects.json";
    public static String treeNode= "src/main/java/LawDirection/TreeNodes.json";
    public static String subjectDirectory = "src/main/java/LawDirection/SubjectDirectory";
    public static  String test = "src/main/java/LawDirection/test";
    public static String fail = "src/main/java/LawDirection/fail";

    public static String path1 = "src/main/java/LawDirection/Part1";
    public static String path2 = "src/main/java/LawDirection/Part2";
    public static String path3 = "src/main/java/LawDirection/Part3";
    public static String path4 = "src/main/java/LawDirection/Part4";
    public static String path5 = "src/main/java/LawDirection/Part5";
    public static String path6 = "src/main/java/LawDirection/Part6";
    public static String path7 = "src/main/java/LawDirection/Part7";

    public static void main(String[] args) throws IOException {

        Helpers helpers = new Helpers();
        Crawler crawler = new Crawler(helpers);
        Pdtopic pdtopic = new Pdtopic();
        Pdsubject pdsubject = new Pdsubject();


       JsonArray topics= crawler.loadData(topicFile);
        crawler.insertData(topics,pdtopic);

        JsonArray subjects = crawler.loadData(subjectFile);
        crawler.insertData(subjects,pdsubject);

        crawler.insertElements(path7,treeNode);

    }
}

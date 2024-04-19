import Controller.Crawler;
import Helper.Helpers;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.persistence.*;
import model.Pdsubject;
import model.Pdtopic;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import Repository.HibernateUtil;

public class Main {
    public static String topicFile = "src/main/java/LawDirection/Topics.json";
    public static String subjectFile = "src/main/java/LawDirection/Subjects.json";
    public static String TreeNodeFile= "src/main/java/LawDirection/TreeNodes.json";
    public static String Subjects = "src/main/java/LawDirection/SubjectDirection";

    public static void main(String[] args) throws IOException {

        Helpers helpers = new Helpers();
        Crawler crawler = new Crawler(helpers);
        Pdtopic pdtopic = new Pdtopic();
        Pdsubject pdsubject = new Pdsubject();

        JsonArray topics= crawler.loadData(topicFile);
        crawler.insertData(topics,pdtopic);

        JsonArray subjects = crawler.loadData(subjectFile);
        crawler.insertData(subjects,pdsubject);




        crawler.insertElements();
    }
}

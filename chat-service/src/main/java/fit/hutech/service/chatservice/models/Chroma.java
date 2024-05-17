package fit.hutech.service.chatservice.models;

import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.chroma.ChromaEmbeddingStore;
import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

public class Chroma {

    public static String chromaUrl = System.getenv("CHROMA_URL");
    public static String collectionName = System.getenv("CHROMA_COLLECTION_NAME");

    public static final EmbeddingStore<TextSegment> embeddingStore =
            ChromaEmbeddingStore.builder()
                    .baseUrl(chromaUrl)
                    .collectionName(collectionName)
                    .build();

    public static String apiKey = System.getenv("OPENAI_API_KEY");

    public static Integer TOKEN_LIMIT = 8000;

    public static final EmbeddingModel embeddingModel =
            OpenAiEmbeddingModel.builder()
                    .apiKey(apiKey)
                    .modelName("text-embedding-ada-002")
                    .build();

    public static TextSegment processData(String id, String name, String subjectName,
                                          String chapterName, String topicName, String content,
                                          String index, String vbqppl, String vbqpplLink, Integer order) {

        Metadata metadata = new Metadata();

        if(id != null && !id.isEmpty())
            metadata.add("id", id);
        if(name != null && !name.isEmpty())
            metadata.add("name", name);
        if(subjectName != null && !subjectName.isEmpty())
            metadata.add("subject_name", subjectName);
        if(chapterName != null && !chapterName.isEmpty())
            metadata.add("chapter_name", chapterName);
        if(topicName != null && !topicName.isEmpty())
            metadata.add("topic_name", topicName);
        if(index != null && !index.isEmpty())
            metadata.add("index", index);
        if(vbqppl != null && !vbqppl.isEmpty())
            metadata.add("vbqppl", vbqppl);
        if(vbqpplLink != null && !vbqpplLink.isEmpty())
            metadata.add("vbqppl_link", vbqpplLink);
        if(order != null)
            metadata.add("order", order);

        if(content != null && !content.isEmpty())
            return TextSegment.from(content, metadata);
        return TextSegment.from(vbqppl, metadata);
    }

    public static void importDataFromMySQL() {
        System.out.println("Connected!");
        String hostname = "localhost";
        String port = "3006";
        String database = "testlaw";

        String jdbcUrl = "jdbc:mysql://" + hostname + ":" + port + "/" + database;
        String username = "root";
        String password = "password";

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
            System.out.println("Connected to database!");

            // Thực hiện các truy vấn và cập nhật của bạn ở đây

            connection.close();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

//        try (Connection conn = DriverManager.getConnection(jdbcUrl, username, password)) {
//            String query = "SELECT pdarticle.id,pdarticle.name,pdsubject.name AS subject_name,pdchapter.name AS chapter_name,pdtopic.name AS topic_name,pdarticle.content,pdarticle.`index`,pdarticle.vbqppl,pdarticle.vbqppl_link,pdarticle.`order` FROM pdarticle INNER JOIN pdsubject ON pdarticle.id_subject = pdsubject.id INNER JOIN pdchapter ON pdarticle.id_chapter = pdchapter.id INNER JOIN pdtopic ON pdarticle.id_topic = pdtopic.id";
//            ResultSet rs = conn.createStatement().executeQuery(query);
//            System.out.println("Connected to database!");
//            while (rs.next()) {
//                TextSegment segment = processData(rs.getString("id"), rs.getString("name"), ..., rs.getString("order")); // Adjust column names
//                Embedding embedding = embeddingModel.embed(segment).content();
//                embeddingStore.add(embedding, segment);
//            }
//        } catch (SQLException e) {
//            System.out.println("Error");
//        }
    }
}
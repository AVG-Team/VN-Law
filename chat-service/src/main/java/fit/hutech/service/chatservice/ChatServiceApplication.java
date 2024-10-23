package fit.hutech.service.chatservice;

import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.store.embedding.EmbeddingMatch;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import static fit.hutech.service.chatservice.models.Chroma.*;

import java.util.List;

@SpringBootApplication

public class ChatServiceApplication {

    public static String chromaUrl = System.getenv("CHROMA_URL");
    public static String collectionName = System.getenv("CHROMA_COLLECTION_NAME");

    public static void main(String[] args) {
        System.out.println("Chroma URL: " + chromaUrl);
        System.out.println("Chroma URL: " + collectionName);
        SpringApplication.run(ChatServiceApplication.class, args);
    }

}

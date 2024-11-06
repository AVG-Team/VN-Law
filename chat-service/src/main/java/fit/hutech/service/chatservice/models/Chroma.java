package fit.hutech.service.chatservice.models;

import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.openai.OpenAiEmbeddingModel;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.chroma.ChromaEmbeddingStore;
import dev.langchain4j.data.document.Metadata;

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
        System.out.println("Processing data API KEY " + apiKey);

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

    public static TextSegment processData(Integer id, String content, String name, String type, String number, String html)
    {
        Metadata metadata = new Metadata();
        if (id != null)
            metadata.add("id", String.valueOf(id));
        if (name != null && !name.isEmpty())
            metadata.add("name", name);
        if (type != null && !type.isEmpty())
            metadata.add("type", type);
        if (number != null && !number.isEmpty())
            metadata.add("number", number);
        if (html != null && !html.isEmpty())
            metadata.add("html", html);
        return TextSegment.from(content, metadata);
    }
}
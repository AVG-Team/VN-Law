package fit.hutech.service.chatservice.services.implement;

import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.DTO.VbqpplDTO;
import fit.hutech.service.chatservice.models.Chroma;
import fit.hutech.service.chatservice.models.Vbqppl;
import fit.hutech.service.chatservice.services.ArticleService;
import fit.hutech.service.chatservice.services.ChromaService;
import dev.langchain4j.model.openai.OpenAiTokenizer;
import fit.hutech.service.chatservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import tech.amikos.chromadb.Client;
import tech.amikos.chromadb.Collection;
import tech.amikos.chromadb.EmbeddingFunction;
import tech.amikos.chromadb.OpenAIEmbeddingFunction;
import tech.amikos.chromadb.handler.ApiException;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static fit.hutech.service.chatservice.models.Chroma.*;

@Service
@RequiredArgsConstructor
public class ChromaServiceImpl implements ChromaService {
    private final ArticleService articleService;
    private final VbqpplService vbqpplService;
    private static final OpenAiTokenizer tokenizer = new OpenAiTokenizer("text-embedding-ada-002"); // Khởi tạo tokenizer chỉ 1 lần

    private static List<String> splitContentIntoChunks(String content) {
        List<String> chunks = new ArrayList<>();
        String[] words = content.split(" ");
        StringBuilder chunk = new StringBuilder();

        for (String word : words) {
            if (chunk.length() + word.length() + 1 > 8000) {
                chunks.add(chunk.toString());
                chunk.setLength(0);
            }
            if (chunk.length() > 0) {
                chunk.append(" ");
            }
            chunk.append(word);
        }
        if (chunk.length() > 0) {
            chunks.add(chunk.toString());
        }

        return chunks;
    }

    private static int countTokens(String text) {
        return tokenizer.estimateTokenCountInText(text);
    }

    private static void createAndStoreEmbeddingArticle(ArticleDTO articleDTO, String content) {
        TextSegment segment = processData(
                articleDTO.getId(), articleDTO.getName(), articleDTO.getSubjectName(),
                articleDTO.getChapterName(), articleDTO.getTopicName(), content,
                articleDTO.getIndex(), articleDTO.getVbqppl(), articleDTO.getVbqpplLink(), articleDTO.getOrder()
        );

        Embedding embedding = embeddingModel.embed(segment).content();
        embeddingStore.add(embedding, segment);
    }

    private static void createAndStoreEmbeddingVbqppl(Vbqppl vbqppl, String content) {
        TextSegment segment = processData(
                vbqppl.getId(), content, vbqppl.getName(), vbqppl.getType(), vbqppl.getNumber(), vbqppl.getHtml()
        );

        Embedding embedding = embeddingModel.embed(segment).content();
        embeddingStore.add(embedding, segment);
    }

    @Override
    public Set<String> getExistingIds() throws ApiException {
        Client client = new Client(System.getenv("CHROMA_URL"));
        String apiKey = System.getenv("OPENAI_API_KEY");

        System.out.println(apiKey + " " + System.getenv("CHROMA_URL"));
        System.out.println(client);
        EmbeddingFunction ef = new OpenAIEmbeddingFunction(apiKey);
        System.out.println(ef);

        Collection collection = client.getCollection(collectionName, ef);
        List<Map<String, Object>> metaData = collection.get().getMetadatas();
        return metaData.stream().map(m -> m.get("id").toString()).collect(Collectors.toSet());
    }

    @Override
    public List<String> importDataFromArticle() throws ApiException {
        Set<String> existingIds = getExistingIds();

        List<String> failed = new ArrayList<>();
        List<ArticleDTO> articles = articleService.getArticlesWithRelatedInfo();
        Integer flag = 0;
        for (ArticleDTO articleDTO : articles) {
            if(existingIds.contains(articleDTO.getId())) {
                System.out.println("skipped " + articleDTO.getId());
                continue;
            } else {
                try {
                    int count_token = countTokens(articleDTO.getContent());
                    String content = articleDTO.getContent();

                    if(count_token > Chroma.TOKEN_LIMIT) {
                        List<String> contentsAfterChunk = splitContentIntoChunks(content);
                        for(String tmp : contentsAfterChunk) {
                            createAndStoreEmbeddingArticle(articleDTO, tmp);
                            System.out.println("success " + tmp);
                        }
                    } else {
                        createAndStoreEmbeddingArticle(articleDTO, content);
                        System.out.println("success " + articleDTO.getId());
                    }
                } catch (Exception e) {
                    failed.add(articleDTO.getId());
                    System.out.println("failed " + articleDTO.getId());
                }
            }
            flag ++;
            System.out.println(flag);
        }
        return failed;
    }

    @Override
    public List<String> importDataFromVbqppl() throws ApiException
    {
        Set<String> existingIds = getExistingIds();

        List<String> failed = new ArrayList<>();
        List<Vbqppl> vbqppls = vbqpplService.getAll();
        Integer flag = 0;
        for (Vbqppl vbqppl : vbqppls) {
            if(existingIds.contains(String.valueOf(vbqppl.getId()))) {
                System.out.println("skipped " + vbqppl.getId());
                continue;
            } else {
                try {
                    int count_token = countTokens(vbqppl.getContent());
                    String content = vbqppl.getContent();

                    if(count_token > Chroma.TOKEN_LIMIT) {
                        List<String> contentsAfterChunk = splitContentIntoChunks(content);
                        for(String tmp : contentsAfterChunk) {
                            createAndStoreEmbeddingVbqppl(vbqppl, tmp);
                            System.out.println("success " + tmp);
                        }
                    } else {
                        createAndStoreEmbeddingVbqppl(vbqppl, content);
                        System.out.println("success " + vbqppl.getId());
                    }
                } catch (Exception e) {
                    failed.add(String.valueOf(vbqppl.getId()));
                    System.out.println("failed " + vbqppl.getId());
                }
            }
            flag ++;
            System.out.println(flag);
        }
        return failed;
    }
}

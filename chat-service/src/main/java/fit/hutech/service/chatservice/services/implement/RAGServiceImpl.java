package fit.hutech.service.chatservice.services.implement;

import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.message.AiMessage;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.input.Prompt;
import dev.langchain4j.model.input.PromptTemplate;
import dev.langchain4j.model.openai.OpenAiChatModel;
import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.DTO.FileDTO;
import fit.hutech.service.chatservice.models.AnswerResult;
import fit.hutech.service.chatservice.models.Chroma;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import fit.hutech.service.chatservice.repositories.FileRepository;
import fit.hutech.service.chatservice.services.RAGService;
import dev.langchain4j.model.openai.OpenAiTokenizer;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import dev.langchain4j.store.embedding.EmbeddingMatch;
import static fit.hutech.service.chatservice.models.Chroma.embeddingModel;
import static fit.hutech.service.chatservice.models.Chroma.embeddingStore;
import java.util.HashMap;
import java.util.Map;

import static java.util.stream.Collectors.joining;
import java.time.Duration;

@Service
@RequiredArgsConstructor
public class RAGServiceImpl implements RAGService {

    private final ArticleRepository articleRepository;
    private final FileRepository fileRepository;

    private static final OpenAiTokenizer tokenizer = new OpenAiTokenizer("text-embedding-ada-002"); // Khởi tạo tokenizer chỉ 1 lần

    @Override
    public List<ArticleDTO> getDataBeyondToken() {
        return articleRepository.getArticlesWithRelatedInfo().stream()
                .filter(this::isBeyondTokenLimit)
                .collect(Collectors.toList());
    }

    private ArticleDTO createArticleDTO(EmbeddingMatch<TextSegment> match) {
        Metadata metadata = match.embedded().metadata();
        List<FileDTO> files = fileRepository.findAllByArticle_IdOrderByArticle(metadata.get("id"));
        return new ArticleDTO(
                metadata.get("id"),
                metadata.get("name"),
                metadata.get("content"),
                metadata.get("index"),
                metadata.get("vbqppl"),
                metadata.get("vbqppl_link"),
                Integer.valueOf(metadata.get("order")),
                metadata.get("subject"),
                metadata.get("chapter"),
                metadata.get("topic"),
                files
        );
    }

    private List<Metadata> getMetadataList(List<EmbeddingMatch<TextSegment>> relevantEmbeddings) {
        return relevantEmbeddings.stream()
                .map(match -> match.embedded().metadata())
                .collect(Collectors.toList());
    }

    @Override
    public AnswerResult getAnswer(String question) {
        System.out.println("question : " + question);
        Embedding questionEmbedding = embeddingModel.embed(question).content();

        int maxResults = 3;
        double minScore = 0.7;

        List<EmbeddingMatch<TextSegment>> relevantEmbeddings
                = embeddingStore.findRelevant(questionEmbedding, maxResults, minScore);

        PromptTemplate promptTemplate = PromptTemplate.from(
                "Trả lời câu hỏi sau theo khả năng tốt nhất của bạn và dùng các từ có tính tôn trọng:\n"
                        + "\n"
                        + "Câu hỏi:\n"
                        + "{{question}}\n"
                        + "\n"
                        + "Dựa trên câu trả lời sau : \n"
                        + "{{contents}}" + "\n"
                        + "\n"
                        + "Và bạn luôn phải trả lời bằng tiếng việt" + "\n"
        );

        String information = relevantEmbeddings.stream()
                .map(match -> match.embedded().text())
                .collect(joining("\n\n"));

        Map<String, Object> variables = new HashMap<>();
        variables.put("question", question);
        variables.put("contents", information);

        Prompt prompt = promptTemplate.apply(variables);

        ChatMemory chatMemory = MessageWindowChatMemory.withMaxMessages(10);

        // Initialize
        ChatLanguageModel chatModel = OpenAiChatModel.builder()
                .apiKey(Chroma.apiKey)
                .modelName("gpt-3.5-turbo-16k")
                .timeout(Duration.ofSeconds(60))
                .build();

        AiMessage aiMessage = chatModel.generate(prompt.toUserMessage()).content();

        List<ArticleDTO> listArticleDTO = relevantEmbeddings.stream()
                .map(this::createArticleDTO)
                .toList();

        return new AnswerResult(aiMessage.text(), listArticleDTO);
    }

    private boolean isBeyondTokenLimit(ArticleDTO articleDTO) {
        System.out.println("Counting tokens in article: " + articleDTO.getId());
        return articleDTO.getContent() != null && countTokens(articleDTO.getContent()) > Chroma.TOKEN_LIMIT;
    }

    private static int countTokens(String text) {
        return tokenizer.estimateTokenCountInText(text);
    }
}

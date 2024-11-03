package fit.hutech.service.chatservice.services;

import dev.langchain4j.data.document.Metadata;
import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.model.input.Prompt;
import dev.langchain4j.model.input.PromptTemplate;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.model.openai.OpenAiTokenizer;
import dev.langchain4j.store.embedding.EmbeddingMatch;
import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.DTO.FileDTO;
import fit.hutech.service.chatservice.DTO.VbqpplDTO;
import fit.hutech.service.chatservice.models.*;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import fit.hutech.service.chatservice.repositories.FileRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

import static fit.hutech.service.chatservice.models.Chroma.embeddingModel;
import static fit.hutech.service.chatservice.models.Chroma.embeddingStore;
import static java.util.stream.Collectors.joining;

@Service
@RequiredArgsConstructor
public class RAGService {

    private static final Logger log = LoggerFactory.getLogger(RAGService.class);
    private final ArticleRepository articleRepository;
    private final FileRepository fileRepository;
    private static final OpenAiTokenizer tokenizer = new OpenAiTokenizer("text-embedding-ada-002");

    // Các thông số có thể điều chỉnh
    private static final int MAX_RESULTS = 5;
    private static final double MIN_SCORE = 0.8;
    private static final double MIN_RELEVANCE_THRESHOLD = 0.7;


    public AnswerResult getAnswer(String question) {
        log.info("Processing question: {}", question);

        try {
            // 1. Tạo embedding cho câu hỏi
            Embedding questionEmbedding = embeddingModel.embed(question).content();
            System.out.println("hh1");
            // 2. Tìm và xếp hạng lại các đoạn văn liên quan
            List<EmbeddingMatch<TextSegment>> relevantEmbeddings = findAndRerankRelevantEmbeddings(
                    questionEmbedding,
                    question
            );
            System.out.println("hh2");

            // 3. Kiểm tra kết quả tìm kiếm
            if (isInsufficientResults(relevantEmbeddings)) {
                return createNoAnswerResult();
            }

            System.out.println("hh3");
            // 4. Xử lý thông tin và tạo câu trả lời
            String processedInformation = processRelevantInformation(relevantEmbeddings);
            System.out.println("hh4");
            String aiResponse = generateAIResponse(question, processedInformation);
            System.out.println("hh5");

            // 5. Tạo kết quả phù hợp với loại dữ liệu
            return createTypedResult(aiResponse, relevantEmbeddings);


        } catch (Exception e) {
            log.error("Error processing question: {}", e.getMessage(), e);
            return new AnswerResult(
                    "Xin lỗi, đã có lỗi xảy ra trong quá trình xử lý câu hỏi. Vui lòng thử lại sau.",
                    null,
                    TypeAnswerResult.NOANSWER
            );
        }
    }

    private List<EmbeddingMatch<TextSegment>> findAndRerankRelevantEmbeddings(
            Embedding questionEmbedding,
            String question
    ) {
        // Tìm các đoạn văn liên quan
        List<EmbeddingMatch<TextSegment>> matches = embeddingStore.findRelevant(
                questionEmbedding,
                MAX_RESULTS,
                MIN_SCORE
        );

        // Xếp hạng lại dựa trên nhiều tiêu chí
        return matches.stream()
                .sorted(Comparator.comparingDouble(match ->
                        calculateRelevanceScore(match, question)))
                .collect(Collectors.toList());
    }

    private double calculateRelevanceScore(EmbeddingMatch<TextSegment> match, String question) {
        double semanticScore = match.score();
        double keywordScore = calculateKeywordOverlap(match.embedded().text(), question);
        double contextScore = calculateContextScore(match);

        // Trọng số cho từng tiêu chí
        return semanticScore * 0.6 + keywordScore * 0.3 + contextScore * 0.1;
    }

    private double calculateKeywordOverlap(String text, String question) {
        Set<String> textWords = new HashSet<>(Arrays.asList(
                text.toLowerCase().replaceAll("[^a-zA-Z0-9\\s]", "").split("\\s+")));
        Set<String> questionWords = new HashSet<>(Arrays.asList(
                question.toLowerCase().replaceAll("[^a-zA-Z0-9\\s]", "").split("\\s+")));

        long commonWords = questionWords.stream()
                .filter(textWords::contains)
                .count();

        return questionWords.isEmpty() ? 0 : (double) commonWords / questionWords.size();
    }

    private double calculateContextScore(EmbeddingMatch<TextSegment> match) {
        // Đánh giá chất lượng ngữ cảnh dựa trên metadata
        Metadata metadata = match.embedded().metadata();
        double score = 1.0;

        // Ưu tiên các đoạn có thông tin đầy đủ
        if (metadata.get("vbqppl") != null) score *= 1.2;
        if (metadata.get("number") != null) score *= 1.1;
        if (metadata.get("subject") != null) score *= 1.1;

        return Math.min(score, 1.0); // Giới hạn điểm tối đa là 1.0
    }

    private String processRelevantInformation(List<EmbeddingMatch<TextSegment>> embeddings) {
        return embeddings.stream()
                .map(match -> {
                    String text = match.embedded().text();
                    Metadata metadata = match.embedded().metadata();
                    String source = metadata.get("vbqppl") != null ?
                            "Văn bản: " + metadata.get("vbqppl") :
                            metadata.get("number") != null ?
                                    "Số: " + metadata.get("number") :
                                    "Nguồn tham khảo";

                    return String.format("%s\nTrích dẫn: %s\n", source, text);
                })
                .collect(joining("\n"));
    }

    private String generateAIResponse(String question, String information) {
        PromptTemplate promptTemplate = PromptTemplate.from(
                "Hãy trả lời câu hỏi dưới đây một cách chính xác và chuyên nghiệp:\n\n" +
                        "Câu hỏi: {{question}}\n\n" +
                        "Dựa trên các thông tin sau:\n{{information}}\n\n" +
                        "Yêu cầu khi trả lời:\n" +
                        "1. Phải dựa trực tiếp vào thông tin được cung cấp\n" +
                        "2. Trích dẫn cụ thể các điều khoản, văn bản liên quan\n" +
                        "3. Sắp xếp nội dung theo thứ tự ưu tiên và độ liên quan\n" +
                        "4. Trả lời bằng tiếng Việt, rõ ràng và dễ hiểu\n" +
                        "5. Nếu thông tin không đủ, hãy nêu rõ phần nào còn thiếu\n"
        );

        Map<String, Object> variables = new HashMap<>();
        variables.put("question", question);
        variables.put("information", information);

        Prompt prompt = promptTemplate.apply(variables);

        ChatLanguageModel chatModel = OpenAiChatModel.builder()
                .apiKey(Chroma.apiKey)
                .modelName("gpt-3.5-turbo-16k")
                .temperature(0.3) // Giảm temperature để câu trả lời chặt chẽ hơn
                .timeout(Duration.ofSeconds(60))
                .build();

        return chatModel.generate(prompt.toUserMessage()).content().text();
    }

    private boolean isInsufficientResults(List<EmbeddingMatch<TextSegment>> embeddings) {
        return embeddings.isEmpty() ||
                embeddings.stream().allMatch(m -> m.score() < MIN_RELEVANCE_THRESHOLD);
    }

    private AnswerResult createNoAnswerResult() {
        return new AnswerResult(
                "Xin lỗi, tôi không tìm thấy thông tin đủ liên quan để trả lời câu hỏi của bạn. " +
                        "Vui lòng điều chỉnh câu hỏi hoặc cung cấp thêm ngữ cảnh.",
                null,
                TypeAnswerResult.NOANSWER
        );
    }

    private AnswerResult createTypedResult(String aiResponse, List<EmbeddingMatch<TextSegment>> matches) {
        EmbeddingMatch<TextSegment> primaryMatch = matches.getFirst();
        Metadata metadata = primaryMatch.embedded().metadata();

        // Xác định loại kết quả dựa trên metadata
        String isArticle = metadata.get("vbqppl");
        String isVbqppl = metadata.get("number");

        if (isArticle != null) {
            List<ArticleDTO> articles = matches.stream()
                    .map(this::createArticleDTO)
                    .collect(Collectors.toList());
            return new AnswerResult(aiResponse, articles, TypeAnswerResult.ARTICLE);
        } else if (isVbqppl != null) {
            List<VbqpplDTO> vbqppls = matches.stream()
                    .map(this::createVbqppl)
                    .collect(Collectors.toList());
            return new AnswerResult(aiResponse, vbqppls, TypeAnswerResult.VBQPPL);
        } else {
            List<Question> questions = matches.stream()
                    .map(this::createQuestion)
                    .collect(Collectors.toList());
            return new AnswerResult(aiResponse, questions, TypeAnswerResult.QUESTION);
        }
    }

    // Giữ nguyên các phương thức helper hiện có
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

    private VbqpplDTO createVbqppl(EmbeddingMatch<TextSegment> match) {
        Metadata metadata = match.embedded().metadata();
        return new VbqpplDTO(
                metadata.get("id"),
                metadata.get("content"),
                metadata.get("type"),
                metadata.get("name"),
                metadata.get("number"),
                metadata.get("html")
        );
    }

    private Question createQuestion(EmbeddingMatch<TextSegment> match) {
        Metadata metadata = match.embedded().metadata();
        return new Question(
                metadata.get("question"),
                metadata.get("answer")
        );
    }

    public List<ArticleDTO> getDataBeyondToken() {
        return articleRepository.getArticlesWithRelatedInfo().stream()
                .filter(this::isBeyondTokenLimit)
                .collect(Collectors.toList());
    }

    private boolean isBeyondTokenLimit(ArticleDTO articleDTO) {
        log.debug("Checking token limit for article: {}", articleDTO.getId());
        return articleDTO.getContent() != null &&
                countTokens(articleDTO.getContent()) > Chroma.TOKEN_LIMIT;
    }

    private static int countTokens(String text) {
        return tokenizer.estimateTokenCountInText(text);
    }
}
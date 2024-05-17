package fit.hutech.service.chatservice.controllers;

import fit.hutech.service.chatservice.models.AnswerResult;
import fit.hutech.service.chatservice.services.ChromaService;
import fit.hutech.service.chatservice.services.RAGService;
import fit.hutech.service.chatservice.services.ArticleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import tech.amikos.chromadb.Client;
import tech.amikos.chromadb.Collection;
import tech.amikos.chromadb.EmbeddingFunction;
import tech.amikos.chromadb.OpenAIEmbeddingFunction;
import tech.amikos.chromadb.handler.ApiException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static fit.hutech.service.chatservice.models.Chroma.*;


@RestController
@RequestMapping("/rag")
public class RAGController {
    private final ArticleService articleService;
    private final RAGService ragService;
    private final ChromaService chromaService;

    public RAGController(ArticleService articleService, RAGService ragService, ChromaService chromaService) {
        this.articleService = articleService;
        this.ragService = ragService;
        this.chromaService = chromaService;
    }

    @GetMapping("/get-all")
    public ResponseEntity<ArticleDTO> getAllArticles() {
        List<ArticleDTO> articles = articleService.getArticlesWithRelatedInfo();
        return new ResponseEntity<>(articles.getFirst(), HttpStatus.OK);
    }

    @GetMapping("/get-all-data-chroma")
    public ResponseEntity<?> getTest() throws ApiException {
        Client client = new Client(System.getenv("CHROMA_URL"));
        String apiKey = System.getenv("OPENAI_API_KEY");

        System.out.println(apiKey + " " + System.getenv("CHROMA_URL"));
        System.out.println(client);
        EmbeddingFunction ef = new OpenAIEmbeddingFunction(apiKey);
        System.out.println(ef);

        Collection collection = client.getCollection(System.getenv("CHROMA_COLLECTION_NAME"), ef);
        return new ResponseEntity<>(collection.get(), HttpStatus.OK);
    }

    @GetMapping("/import-data-from-article")
    public ResponseEntity<List<String>> ImportDataFromArticle() throws ApiException {
        List<String> failed = chromaService.importDataFromArticle();
        return new ResponseEntity<>(failed, HttpStatus.OK);
    }

    @GetMapping("/get-map")
    public ResponseEntity<?> getMap() throws ApiException {
        Set<String> map = chromaService.getExistingIds();
        return new ResponseEntity<>(map, HttpStatus.OK);
    }

    @GetMapping("/get-answer")
    public ResponseEntity<AnswerResult> getAnswer(@RequestParam String question) {
//        String question = "mức phụ cấp hàng tháng đối với các chức danh như nào ?";
        AnswerResult answer = ragService.getAnswer(question);
        return new ResponseEntity<>(answer, HttpStatus.OK);
    }
}

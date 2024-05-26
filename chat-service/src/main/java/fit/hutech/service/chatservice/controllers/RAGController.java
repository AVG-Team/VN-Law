package fit.hutech.service.chatservice.controllers;

import fit.hutech.service.chatservice.models.*;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import fit.hutech.service.chatservice.repositories.VbqpplRepository;
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
import tech.amikos.chromadb.handler.ApiClient;
import tech.amikos.chromadb.handler.ApiException;

import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static fit.hutech.service.chatservice.models.Chroma.*;


@RestController
@RequestMapping("/chat-service/rag")
public class RAGController {
    private final ArticleService articleService;
    private final RAGService ragService;
    private final ChromaService chromaService;
    private final ArticleRepository articleRepository;

    public RAGController(ArticleService articleService, RAGService ragService, ChromaService chromaService, ArticleRepository articleRepository) {
        this.articleService = articleService;
        this.ragService = ragService;
        this.chromaService = chromaService;
        this.articleRepository = articleRepository;
    }

//    @GetMapping("/get-all")
//    public ResponseEntity<ArticleDTO> getAllArticles() {
//        List<ArticleDTO> articles = articleService.getArticlesWithRelatedInfo();
//        return new ResponseEntity<>(articles.getFirst(), HttpStatus.OK);
//    }
//
    @GetMapping("/get-all-data-chroma")
    public ResponseEntity<?> getTest() throws ApiException {
        Client client = new Client(chromaUrl);
        String serverName = "localhost";
        int port = 8080;

        System.out.println(client.version());

        ApiClient apiClient = new ApiClient();
        apiClient.setBasePath(chromaUrl);


        System.out.println(apiKey + " " + chromaUrl);
        System.out.println(client);
        EmbeddingFunction ef = new OpenAIEmbeddingFunction(apiKey);
        System.out.println(ef);

        Collection collection = client.getCollection(System.getenv("CHROMA_COLLECTION_NAME"), ef);
        return new ResponseEntity<>(collection.get().getMetadatas(), HttpStatus.OK);
    }
//
    @GetMapping("/import-data-from-article")
    public ResponseEntity<List<String>> ImportDataFromArticle() throws ApiException {
        List<String> failed = chromaService.importDataFromArticle();
        return new ResponseEntity<>(failed, HttpStatus.OK);
    }

    @GetMapping("/import-data-from-vbqppl")
    public ResponseEntity<?> ImportDataFromVbqppl() throws ApiException {
        List<String> failed = chromaService.importDataFromVbqppl();
        return new ResponseEntity<>(failed, HttpStatus.OK);
    }

    @GetMapping("test")
    public ResponseEntity<String> helloWorld()
    {
        return ResponseEntity.ok("Hello World 12345");
    }

    @GetMapping("test-save-file")
    public ResponseEntity<String> saveFile() throws FileNotFoundException {
        System.out.println(123);
        PrintStream fileOut = new PrintStream("D:\\\\logVnLaw\\\\log.txt");
        System.setOut(fileOut);
        System.out.println("Hello World");
        fileOut.close();
        return ResponseEntity.ok("Save File Success");
    }

    @GetMapping("test-save-article")
    public ResponseEntity<String> saveArticle()
    {
        Article article = articleRepository.findById("0100100000000000100000100000000000000000").get();
        System.out.println(article);
        article.setIsEmbedded(true);
        articleService.save(article);
        return ResponseEntity.ok("Save Article Success");
    }

    @GetMapping("test-answer")
    public ResponseEntity<AnswerResult> getTestAnswer()
    {
        AnswerResult answer = new AnswerResult("Test Answer", TypeAnswerResult.NOANSWER);
        return new ResponseEntity<>(answer, HttpStatus.OK);
    }

//    @GetMapping("/get-map")
//    public ResponseEntity<?> getMap() throws ApiException {
//        Set<String> map = chromaService.getExistingIds();
//        return new ResponseEntity<>(map, HttpStatus.OK);
//    }

    @GetMapping("/get-answer")
    public ResponseEntity<AnswerResult> getAnswer(@RequestParam String question) {
        System.out.println("Question RAG: " + question);
        AnswerResult answer = ragService.getAnswer(question);
        return new ResponseEntity<>(answer, HttpStatus.OK);
    }
}

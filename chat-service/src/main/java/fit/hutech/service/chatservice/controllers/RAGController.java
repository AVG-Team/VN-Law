package fit.hutech.service.chatservice.controllers;

import fit.hutech.service.chatservice.models.*;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import fit.hutech.service.chatservice.services.ArticleService;
import fit.hutech.service.chatservice.services.ChromaService;
import fit.hutech.service.chatservice.services.RAGService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import tech.amikos.chromadb.Client;
import tech.amikos.chromadb.Collection;
import tech.amikos.chromadb.EmbeddingFunction;
import tech.amikos.chromadb.OpenAIEmbeddingFunction;
import tech.amikos.chromadb.handler.ApiClient;
import tech.amikos.chromadb.handler.ApiException;

import java.util.List;

import static fit.hutech.service.chatservice.models.Chroma.*;


@RestController
@RequestMapping("/chat-service/rag")
@RequiredArgsConstructor
public class RAGController {
    private final ArticleService articleService;
    private final RAGService ragService;
    private final ChromaService chromaService;
    private final ArticleRepository articleRepository;


    @GetMapping("/get-all-data-chroma")
    public ResponseEntity<?> getTest() throws ApiException {
        Client client = new Client(chromaUrl);
        client.setTimeout(1000);
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

    @GetMapping("/import-data-from-file-article")
    public ResponseEntity<List<String>> ImportDataFromFileArticle() throws ApiException {
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

    public String createCrhomaData() {

        return "Create Chroma Data";
    }
}

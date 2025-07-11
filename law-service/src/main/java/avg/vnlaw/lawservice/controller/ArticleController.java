package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.response.ArticleResponse;
import avg.vnlaw.lawservice.elastic.services.ArticleDocumentService;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.services.ArticleService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("law/api/article")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;
    private final ArticleDocumentService articleDocumentService;
    private final Logger log = LoggerFactory.getLogger(ArticleService.class);


    @GetMapping("/{chapterId}")
    public ResponseEntity<Object> getArticleByChapter(@PathVariable String chapterId,
                                                      @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
                                                      @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize){
        Page<ArticleResponse> articles = articleService.getArticleByChapter(chapterId,pageNo,pageSize);
        log.info("Get article success id {}", articles.toString());
        return HandlerResponse.responseBuilder("Get article by chapter successfully",
                HttpStatus.OK,articles);
    }

    @GetMapping("/tree/{articleId}")
    public ResponseEntity<Object> getArticleTreeViewById(@PathVariable String articleId) throws AppException {
        return HandlerResponse.responseBuilder("Get article tree by article Id successfully ",
                HttpStatus.OK,articleService.getTreeViewByArticleId(articleId));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getArticleByFilter(
            @RequestParam(name = "subjectId", value="subjectId") Optional<String> subjectId,
            @RequestParam(name = "name", value="name") Optional<String> name,
            @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize
    ){
        return HandlerResponse.responseBuilder("Get article by filter successfully",
                HttpStatus.OK,articleService.getArticleByFilter(subjectId,name,pageNo,pageSize));
    }

    @GetMapping("/search")
    public ResponseEntity<Object> getArticleBySearch(@RequestParam(name = "keywords", value= "keywords") String keywords){
        return HandlerResponse.responseBuilder("Get article by search successfully",
                HttpStatus.OK,articleDocumentService.search(keywords));
    }

}

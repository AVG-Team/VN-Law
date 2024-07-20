package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.responses.ResponseHandler;
import avg.vnlaw.lawservice.services.ArticleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/v1/article")
public class ArticleController {
    private final ArticleService articleService;

    public ArticleController(ArticleService articleService){
        this.articleService = articleService;
    }

    @GetMapping("/{chapterId}")
    public ResponseEntity<Object> getArticleByChapter(@PathVariable String chapterId,
                                                      @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
                                                      @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,articleService.getArticleByChapter(chapterId,pageNo,pageSize));
    }

    @GetMapping("/tree/{articleId}")
    public ResponseEntity<Object> getArticleTreeViewById(@PathVariable String articleId) throws NotFoundException {
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,articleService.getTreeViewByArticleId(articleId));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getArticleByFilter(
            @RequestParam(name = "subjectId", value="subjectId") Optional<String> subjectId,
            @RequestParam(name = "name", value="name") Optional<String> name,
            @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,articleService.getArticleByFilter(subjectId,name,pageNo,pageSize));
    }

}

package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.services.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/article")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;


    @GetMapping("/{chapterId}")
    public ResponseEntity<Object> getArticleByChapter(@PathVariable String chapterId,
                                                      @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
                                                      @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,articleService.getArticleByChapter(chapterId,pageNo,pageSize));
    }

    @GetMapping("/tree/{articleId}")
    public ResponseEntity<Object> getArticleTreeViewById(@PathVariable String articleId) throws AppException {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,articleService.getTreeViewByArticleId(articleId));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getArticleByFilter(
            @RequestParam(name = "subjectId", value="subjectId") Optional<String> subjectId,
            @RequestParam(name = "name", value="name") Optional<String> name,
            @RequestParam(name = "pageNo", value="pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value="pageSize") Optional<Integer> pageSize
    ){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,articleService.getArticleByFilter(subjectId,name,pageNo,pageSize));
    }
}

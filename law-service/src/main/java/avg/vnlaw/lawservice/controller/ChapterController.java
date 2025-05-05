package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.ChapterRequest;
import avg.vnlaw.lawservice.elastic.documents.ChapterDocument;
import avg.vnlaw.lawservice.elastic.services.ChapterDocumentService;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.services.ChapterService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("law/api/chapter")
@RequiredArgsConstructor
public class ChapterController{

    private ChapterService chapterService;
    private ChapterDocumentService chapterDocumentService;

    public ChapterController(ChapterService chapterService){
        this.chapterService = chapterService;
    }

    @GetMapping("/{chapterId}")
    public ResponseEntity<Object> getChapterById(@PathVariable(name = "chapterId") String chapterId) throws AppException {
        return HandlerResponse.responseBuilder("Get chapter by id successfully",
                HttpStatus.OK,this.chapterService.getChapter(chapterId));
    }

    @GetMapping("/{subjectId}")
    public ResponseEntity<Object> getChapterBySubject(@PathVariable(name = "subjectId") String subjectId) throws AppException{
        return HandlerResponse.responseBuilder("Get chapter by subjectId successfully",
                HttpStatus.OK,this.chapterService.getChaptersBySubject(subjectId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllChapters() throws AppException {
        return HandlerResponse.responseBuilder("Get all chapters successfully",
                HttpStatus.OK,this.chapterService.getAllChapters());
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllChapters(
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name,
            @RequestParam(name = "pageNo", value ="pageNo", defaultValue = "" ) Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value= "pageSize", defaultValue = "") Optional<Integer> pageSize
    ){
       return HandlerResponse.responseBuilder("Filter chapters successfully",
               HttpStatus.OK,this.chapterService.getAllChapters(name,pageNo,pageSize));
    }

    @GetMapping("/search")
    public ResponseEntity<Object> elasticSearch(@RequestParam(name="keyword", value="keyword")String keyword) throws AppException {
        return HandlerResponse.responseBuilder("Search successfully",
                HttpStatus.OK,chapterDocumentService.search(keyword));
    }
}

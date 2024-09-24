package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.ChapterRequest;
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
@RequestMapping("/chapter")
@RequiredArgsConstructor
public class ChapterController extends BaseController <Chapter, ChapterRequest,String>{

    private ChapterService chapterService;

    public ChapterController(ChapterService chapterService){
        this.chapterService = chapterService;
    }

    @GetMapping("{chapterId}")
    public ResponseEntity<Object> getChapterById(@PathVariable(name = "chapterId") String chapterId) throws AppException {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getChapter(chapterId));
    }

    @GetMapping("/{subjectId}")
    public ResponseEntity<Object> getChapterBySubject(@PathVariable(name = "subjectId") String subjectId) throws AppException{
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getChaptersBySubject(subjectId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllChapters() throws AppException {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getAllChapters());
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllChapters(
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name,
            @RequestParam(name = "pageNo", value ="pageNo", defaultValue = "" ) Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value= "pageSize", defaultValue = "") Optional<Integer> pageSize
    ){
       return HandlerResponse.responseBuilder("Complete",
               HttpStatus.OK,this.chapterService.getAllChapters(name,pageNo,pageSize));
    }

    @Override
    public ResponseEntity<Chapter> create(ChapterRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Chapter> update(String id, ChapterRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Chapter> delete(ChapterRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Chapter> get(ChapterRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<List<Chapter>> getAll() {
        return null;
    }
}

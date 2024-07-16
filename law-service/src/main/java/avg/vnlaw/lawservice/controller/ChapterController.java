package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.response.ResponseHandler;
import avg.vnlaw.lawservice.services.ChapterService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/law-service/chapter")
public class ChapterController {

    final ChapterService chapterService;

    public ChapterController(ChapterService chapterService){
        this.chapterService = chapterService;
    }

    @GetMapping("{chapterId}")
    public ResponseEntity<Object> getChapterById(@PathVariable(name = "chapterId") String chapterId) throws NotFoundException {
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getChapter(chapterId));
    }

    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<Object> getChapterBySubject(@PathVariable(name = "subjectId") String subjectId) throws NotFoundException{
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getChaptersBySubject(subjectId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllChapters() throws NotFoundException {
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.chapterService.getAllChapters());
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllChapters(
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name,
            @RequestParam(name = "pageNo", value ="pageNo", defaultValue = "" ) Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value= "pageSize", defaultValue = "") Optional<Integer> pageSize
    ){
       return ResponseHandler.responseBuilder("Complete",
               HttpStatus.OK,this.chapterService.getAllChapters(name,pageNo,pageSize));
    }
}

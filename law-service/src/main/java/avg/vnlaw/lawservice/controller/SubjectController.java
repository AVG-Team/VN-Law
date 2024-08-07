package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.responses.ResponseHandler;
import avg.vnlaw.lawservice.services.SubjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/v1/subject")
public class SubjectController {

    @Autowired
    private SubjectService subjectService;

    public SubjectController(SubjectService subjectService){
        this.subjectService = subjectService;
    }

    @GetMapping("/{topicId}")
    public ResponseEntity<Object> getSubjectByTopic(@PathVariable("topicId") String topicId){
        return ResponseHandler.responseBuilder("Complete Get Subject By Topic ",
                HttpStatus.OK,this.subjectService.getSubjectByTopic(topicId));
    }

    @GetMapping("{subjectId}")
    public ResponseEntity<Object> getSubjectDetail(@PathVariable("subjectId") String subjectId){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.subjectService.getSubject(subjectId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllSubjects(
            @RequestParam(name = "pageNo", value = "pageNo", defaultValue = "") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize", defaultValue = "") Optional<Integer> pageSize,
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.subjectService.getAllSubjects(name,pageNo,pageSize));
    }
}

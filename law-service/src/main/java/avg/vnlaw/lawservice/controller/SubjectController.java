package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.SubjectRequest;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.elastic.services.SubjectDocumentService;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.services.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.logging.Handler;

@RestController
@RequestMapping("/subject")
@RequiredArgsConstructor
public class SubjectController {

    private final SubjectService subjectService;
    private final SubjectDocumentService subjectDocumentService;


    @GetMapping("/{topicId}")
    public ResponseEntity<Object> getSubjectByTopic(@PathVariable("topicId") String topicId){
        return HandlerResponse.responseBuilder("Complete Get Subject By Topic ",
                HttpStatus.OK,subjectService.getSubjectByTopic(topicId));
    }

    @GetMapping("{subjectId}")
    public ResponseEntity<Object> getSubjectDetail(@PathVariable("subjectId") String subjectId){
        return HandlerResponse.responseBuilder("Get subject Detail successfully",
                HttpStatus.OK,subjectService.getSubject(subjectId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllSubjects(
            @RequestParam(name = "pageNo", value = "pageNo", defaultValue = "") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize", defaultValue = "") Optional<Integer> pageSize,
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name
    ){
        return HandlerResponse.responseBuilder("Get all Subjects successfully",
                HttpStatus.OK,subjectService.getAllSubjects(name,pageNo,pageSize));
    }

    @GetMapping("/search")
    public ResponseEntity<Object> elasticSearch(@RequestParam(name="keyword",value="keyword") String keyword){
        return HandlerResponse.responseBuilder("Search successfully",
                HttpStatus.OK,subjectDocumentService.search(keyword));
    }
}

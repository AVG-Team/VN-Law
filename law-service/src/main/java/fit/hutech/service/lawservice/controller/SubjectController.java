package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.DTO.SubjectDTO;
import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.repositories.SubjectRepository;
import fit.hutech.service.lawservice.services.SubjectService;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/subject")
public class SubjectController {

    final SubjectService subjectService;

    public SubjectController(SubjectService subjectService){
        this.subjectService = subjectService;
    }

    @GetMapping("/topic/{topicId}")
    public ResponseEntity<Object> getSubjectByTopic(@PathVariable("topicId") String topicId){
        return ResponseHandler.responseBuilder("Complete Get Subject By Topic ",
                HttpStatus.OK,this.subjectService.getSubjectByTopic(topicId));
    }

    @GetMapping("{subjectId}")
    public ResponseEntity<Object> getSubjectDetail(@PathVariable("subjectId") String subjectId){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.subjectService.getSubject(subjectId));
    }

    @GetMapping("/all")
    public ResponseEntity<Object> getAllSubjectDetails(){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.subjectService.getAllSubjects());
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllSubjects(
            @RequestParam(name = "pageNo", value = "pageNo", defaultValue = "") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize", defaultValue = "") Optional<Integer> pageSize,
            @RequestParam(name = "name", value = "name", defaultValue = "") Optional<String> name
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.subjectService.getAllSubject(name,pageNo,pageSize));
    }
}

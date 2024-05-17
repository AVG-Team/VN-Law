package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.models.Topic;
import fit.hutech.service.lawservice.services.TopicService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/law-service/topic")
public class TopicController {

    final TopicService topicService;

    public TopicController(TopicService topicService){
        this.topicService = topicService;
    }

    @GetMapping("{topicId}")
    public ResponseEntity<Object> getTopicDetails(@PathVariable("topicId") String topicId){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.topicService.getTopic(topicId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllTopicDetails(){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.topicService.getAllTopic());
    }
}

package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.responses.ResponseHandler;
import avg.vnlaw.lawservice.services.TopicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/topic")
public class TopicController {

    @Autowired
    private TopicService topicService;

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

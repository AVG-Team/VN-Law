package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.services.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/topic")
@RequiredArgsConstructor
public class TopicController extends BaseController<Topic, TopicRequest,String> {


    private TopicService topicService;

    public TopicController(TopicService topicService){
        this.topicService = topicService;
    }

    @GetMapping("{topicId}")
    public ResponseEntity<Object> getTopicDetails(@PathVariable("topicId") String topicId){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.topicService.getTopic(topicId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllTopicDetails(){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.topicService.getAllTopic());
    }

    @Override
    public ResponseEntity<Topic> create(TopicRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Topic> update(String id, TopicRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Topic> delete(TopicRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Topic> get(TopicRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<List<Topic>> getAll() {
        return null;
    }
}
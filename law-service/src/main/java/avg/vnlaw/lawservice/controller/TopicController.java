package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.elastic.services.TopicDocumentService;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.services.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/topic")
@RequiredArgsConstructor
public class TopicController  {

    private final TopicService topicService;
    private final TopicDocumentService topicDocumentService;


    @GetMapping("{topicId}")
    public ResponseEntity<Object> getTopicDetails(@PathVariable("topicId") String topicId){
        return HandlerResponse.responseBuilder("Get topic details successfully",
                HttpStatus.OK,topicService.getTopic(topicId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllTopicDetails(){
        return HandlerResponse.responseBuilder("Get all details successfully",
                HttpStatus.OK,topicService.getAllTopic());
    }

    @GetMapping("/search")
    public ResponseEntity<Object> searchTopic(@RequestParam(name="keyword",value="keyword") String keyword){
        return HandlerResponse.responseBuilder("Search topics successfully",
                HttpStatus.OK,topicDocumentService.search(keyword));
    }
}

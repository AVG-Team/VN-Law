package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import avg.vnlaw.lawservice.responses.ResponseTopic;
import avg.vnlaw.lawservice.services.TopicService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TopicServiceImpl implements TopicService {

    final TopicRepository topicRepository;

    @Override
    public ResponseTopic getTopic(String topicId) {
       if(topicRepository.findById(topicId).isEmpty()){
           throw new NotFoundException("Requested Topic doesn't exist");
       }
       return topicRepository.findTopicById(topicId);
    }

    @Override
    public List<ResponseTopic> getAllTopic() {
        List<ResponseTopic> topics = topicRepository.findAllTopics();
        if(topicRepository.findAll().isEmpty()){
            throw new NotFoundException("Requested Topic is empty");
        }
        return topics.stream()
                .sorted(Comparator.comparingInt(ResponseTopic::getOrder))
                .toList();
    }
}

package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.TopicRepository;
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
    public String createTopic(Topic topic) {
        this.topicRepository.save(topic);
        return "Success";
    }

    @Override
    public String updateTopic(Topic topic) {
        this.topicRepository.save(topic);
        return "Success";
    }

    @Override
    public String deleteTopic(Topic topic) {
        return null;
    }

    @Override
    public Topic getTopic(String topicId) {
       if(topicRepository.findById(topicId).isEmpty()){
           throw new NotFoundException("Requested Topic doesn't exist");
       }
       return topicRepository.findById(topicId).get();
    }

    @Override
    public List<Topic> getAllTopic() {
        List<Topic> topics = topicRepository.findAll();
        if(topicRepository.findAll().isEmpty()){
            throw new NotFoundException("Requested Topic is empty");
        }
        return topics.stream()
                .sorted(Comparator.comparingInt(Topic::getOrder))
                .toList();
    }
}

package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.models.Topic;
import fit.hutech.service.lawservice.repositories.TopicRepository;
import fit.hutech.service.lawservice.services.TopicService;
import org.springframework.stereotype.Service;
import fit.hutech.service.lawservice.exception.NotFoundException;
import java.util.Comparator;
import java.util.List;

@Service
public class TopicServiceImpl implements TopicService {

    final TopicRepository topicRepository;

    public TopicServiceImpl(TopicRepository topicRepository){
        this.topicRepository = topicRepository;
    }

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

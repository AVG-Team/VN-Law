package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TopicService implements BaseService<TopicRequest,String> {

    final TopicRepository topicRepository;


    public TopicResponse getTopic(String topicId) {
       if(topicRepository.findById(topicId).isEmpty()){
           throw new NotFoundException("Requested Topic doesn't exist");
       }
       return topicRepository.findTopicById(topicId);
    }


    public List<TopicResponse> getAllTopic() {
        List<TopicResponse> topics = topicRepository.findAllTopics();
        if(topicRepository.findAll().isEmpty()){
            throw new NotFoundException("Requested Topic is empty");
        }
        return topics.stream()
                .sorted(Comparator.comparingInt(TopicResponse::getOrder))
                .toList();
    }

    @Override
    public Optional<TopicRequest> findById(String id) {
        return Optional.empty();
    }

    @Override
    public TopicRequest create(TopicRequest entity) {
        return null;
    }

    @Override
    public TopicRequest update(String id, TopicRequest entity) {
        return null;
    }

    @Override
    public void delete(String id) {

    }
}

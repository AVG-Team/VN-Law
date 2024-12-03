package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TopicService {

    final TopicRepository topicRepository;


    public TopicResponse getTopic(String topicId) {
       if(topicRepository.findById(topicId).isEmpty()){
           throw new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED);
       }
       return topicRepository.findTopicById(topicId);
    }


    public List<TopicResponse> getAllTopic() {
        List<TopicResponse> topics = topicRepository.findAllTopics();
        if(topicRepository.findAll().isEmpty()){
            throw new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED);
        }
        return topics.stream()
                .sorted(Comparator.comparingInt(TopicResponse::getOrder))
                .toList();
    }
}

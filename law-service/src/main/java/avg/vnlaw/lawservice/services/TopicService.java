package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.TopicMapper;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TopicService implements BaseService<TopicRequest,String,TopicResponse> {

    private final TopicRepository topicRepository;
    private final Logger log = LoggerFactory.getLogger(TopicService.class);
    private TopicMapper topicMapper;

    public TopicResponse getTopic(String topicId) {
        log.info("Get topic : {}",topicId);
        if(topicRepository.findById(topicId).isEmpty()){
           throw new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED);
       }
       return topicRepository.findTopicById(topicId);
    }


    public List<TopicResponse> getAllTopic() {
        log.info("Get all topics");
        List<TopicResponse> topics = topicRepository.findAllTopics();
        if(topicRepository.findAll().isEmpty()){
            throw new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED);
        }
        return topics.stream()
                .sorted(Comparator.comparingInt(TopicResponse::getOrder))
                .toList();
    }

    @Override
    public Optional<TopicResponse> findById(String id) {
        log.info("Find topic by id : {}",id);
        if(id == null) throw new AppException(ErrorCode.ID_EMPTY);
        if(topicRepository.findById(id).isEmpty())
            throw new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED);
        Topic topic = topicRepository.findById(id).get();
        return Optional.of(topicMapper.toResponse(topic));
    }

    @Override
    public TopicResponse create(TopicRequest entity) {
        log.info("Create topic : {}",entity);
        if(entity == null) throw new AppException(ErrorCode.TOPIC_NOT_FOUND);
        topicRepository.save(topicMapper.toEntity(entity));
        return topicMapper.requestToResponse(entity);
    }

    @Override
    public TopicResponse update(TopicRequest entity) {
        log.info("Update topic : {}",entity);
        if(entity == null) throw new AppException(ErrorCode.TOPIC_NOT_FOUND);
        if(entity.getId() == null) throw new AppException(ErrorCode.ID_EMPTY);
        topicRepository.save(topicMapper.toEntity(entity));
        return topicMapper.requestToResponse(entity);
    }

    @Override
    public void delete(String id) {
        log.info("Delete topic : {}",id);
        if(id == null) throw new AppException(ErrorCode.ID_EMPTY);
        topicRepository.deleteById(id);
    }
}

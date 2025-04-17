package avg.vnlaw.lawservice.mapper;


import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.entities.Topic;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface  TopicMapper extends BaseMapper<Topic, TopicRequest> {
    TopicResponse toResponse(Topic topic);
    TopicResponse requestToResponse(TopicRequest request);
}

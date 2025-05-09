package avg.vnlaw.lawservice.mapper;


import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.entities.Tables;
import avg.vnlaw.lawservice.entities.Topic;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface  TopicMapper {
    Topic toEntity(TopicRequest request);
    TopicRequest toRequest(Topic topic);
    TopicResponse toResponse(Topic topic);
    TopicResponse requestToResponse(TopicRequest request);
    void updateEntityFromRequest(TopicRequest dto, @MappingTarget Topic entity);
    void updateEntityFromResponse(TopicResponse dto, @MappingTarget Topic entity);
}

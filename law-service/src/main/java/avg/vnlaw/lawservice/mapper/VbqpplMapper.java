package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.TopicRequest;
import avg.vnlaw.lawservice.dto.request.VbqpplRequest;
import avg.vnlaw.lawservice.dto.response.TopicResponse;
import avg.vnlaw.lawservice.dto.response.VbqpplResponse;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.entities.Vbqppl;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface VbqpplMapper {
    Vbqppl toEntity(VbqpplRequest request);
    VbqpplRequest toRequest(Vbqppl vbqppl);
    VbqpplResponse toResponse(Vbqppl vbqppl);
    VbqpplResponse requestToResponse(VbqpplRequest request);
    void updateEntityFromRequest(VbqpplRequest dto, @MappingTarget Vbqppl entity);
    void updateEntityFromResponse(VbqpplResponse dto, @MappingTarget Vbqppl entity);
}

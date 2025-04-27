package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.dto.request.SubjectRequest;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.entities.Subject;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface SubjectMapper {
    Subject toEntity(SubjectRequest request);
    SubjectRequest toRequest(Subject subject);
    SubjectResponse toResponse(Subject subject);
    SubjectResponse requestToResponse(SubjectRequest request);
    void updateEntityFromRequest(SubjectRequest dto, @MappingTarget Subject entity);
    void updateEntityFromResponse(SubjectResponse dto, @MappingTarget Subject entity);
}

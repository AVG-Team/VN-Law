package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.SubjectRequest;
import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.entities.Subject;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface SubjectMapper extends BaseMapper<Subject, SubjectRequest> {
    SubjectResponse toResponse(Subject subject);
    SubjectResponse requestToResponse(SubjectRequest request);
}

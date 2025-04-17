package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.SubjectRequest;
import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Tables;
import jakarta.persistence.Table;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface TableMapper {
    Tables toEntity(TableRequest request);
    TableRequest toRequest(Tables table);
    TableResponse toResponse(Tables table);
    TableResponse requestToResponse(TableRequest request);
    void updateEntityFromRequest(TableRequest dto, @MappingTarget Tables entity);
    void updateEntityFromResponse(TableResponse dto, @MappingTarget Tables entity);
}

package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.FilesRequest;
import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.dto.response.FileResponse;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import avg.vnlaw.lawservice.entities.Files;
import avg.vnlaw.lawservice.entities.IndexVbqppl;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface IndexVbqpplMapper {
    IndexVbqppl toEntity(IndexVbqpplRequest indexVbqpplRequest);
    IndexVbqpplRequest toRequest(IndexVbqppl indexVbqppl);
    IndexVbqpplResponse toResponse(IndexVbqppl indexVbqppl);
    IndexVbqpplResponse requestToResponse(IndexVbqpplRequest request);
    void updateEntityFromRequest(IndexVbqpplRequest dto, @MappingTarget IndexVbqppl entity);
    void updateEntityFromResponse(IndexVbqpplResponse dto, @MappingTarget IndexVbqppl entity);
}

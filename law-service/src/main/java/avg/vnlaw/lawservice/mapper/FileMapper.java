package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.ChapterRequest;
import avg.vnlaw.lawservice.dto.request.FilesRequest;
import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.dto.response.FileResponse;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Files;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

import java.io.File;

@Mapper(componentModel = "spring")
public interface FileMapper {
    Files toEntiy(FilesRequest filesRequest);
    FilesRequest toRequest(Files file);
    FileResponse toResponse(Files file);
    FileResponse requestToResponse(FilesRequest request);
    void updateEntityFromRequest(FilesRequest dto, @MappingTarget Files entity);
    void updateEntityFromResponse(FileResponse dto, @MappingTarget Files entity);
}


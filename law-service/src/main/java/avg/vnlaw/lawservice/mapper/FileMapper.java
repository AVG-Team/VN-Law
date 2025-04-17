package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.FilesRequest;
import avg.vnlaw.lawservice.dto.response.FileResponse;
import org.mapstruct.Mapper;

import java.io.File;

@Mapper(componentModel = "spring")
public interface FileMapper extends BaseMapper<File, FilesRequest> {
    FileResponse toResponse(File file);
    FileResponse requestToResponse(FilesRequest request);
}


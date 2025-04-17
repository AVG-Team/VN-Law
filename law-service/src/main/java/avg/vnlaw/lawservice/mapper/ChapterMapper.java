package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.ChapterRequest;
import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.entities.Chapter;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ChapterMapper extends BaseMapper<Chapter, ChapterRequest> {
    ChapterResponse toResponse(Chapter chapter);
    ChapterResponse requestToResponse(ChapterRequest chapterRequest);
}

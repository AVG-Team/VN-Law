package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.dto.request.ChapterRequest;
import avg.vnlaw.lawservice.dto.response.ArticleResponse;
import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ChapterMapper {
    Chapter toEntity(ChapterRequest chapterRequest);
    ChapterRequest toRequest(Chapter chapter);
    ChapterResponse toResponse(Chapter chapter);
    ChapterResponse requestToResponse(ChapterRequest chapterRequest);
    void updateEntityFromRequest(ChapterRequest dto, @MappingTarget Chapter entity);
    void updateEntityFromResponse(ChapterResponse dto, @MappingTarget Chapter entity);
}

package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.dto.response.ArticleResponse;
import avg.vnlaw.lawservice.entities.Article;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ArticleMapper {
    Article toEntity(ArticleRequest articleRequest);
    ArticleRequest toRequest(Article article);
    ArticleResponse toResponse(Article article);
    ArticleResponse requestToResponse(ArticleRequest request);
    void updateEntityFromRequest(ArticleRequest dto, @MappingTarget Article entity);
    void updateEntityFromResponse(ArticleResponse dto, @MappingTarget Article entity);

}

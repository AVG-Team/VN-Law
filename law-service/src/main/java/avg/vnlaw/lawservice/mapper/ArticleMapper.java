package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.dto.response.ArticleResponse;
import avg.vnlaw.lawservice.entities.Article;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ArticleMapper extends BaseMapper<Article, ArticleRequest> {
    ArticleResponse toResponse(Article article);
    ArticleResponse requestToResponse(ArticleRequest request);
}

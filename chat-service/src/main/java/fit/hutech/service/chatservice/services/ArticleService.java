package fit.hutech.service.chatservice.services;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.models.Article;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface ArticleService {
    public List<ArticleDTO> getArticlesWithRelatedInfo();
    public void save(Article article);
    public Article getArticleById(String id);
}

package fit.hutech.service.chatservice.services;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.models.Article;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleService {

    private final ArticleRepository articleRepository ;


    public List<ArticleDTO> getArticlesWithRelatedInfo() {
        return articleRepository.getArticlesWithRelatedInfo();
    }

    public void save(Article article) {
        articleRepository.save(article);
    }


    public Article getArticleById(String id) {
        return articleRepository.findById(id).orElse(null);
    }
}

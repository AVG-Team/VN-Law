package fit.hutech.service.chatservice.services.implement;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.repositories.ArticleRepository;
import fit.hutech.service.chatservice.services.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository ;

    @Override
    public List<ArticleDTO> getArticlesWithRelatedInfo() {
        return articleRepository.getArticlesWithRelatedInfo();
    }
}

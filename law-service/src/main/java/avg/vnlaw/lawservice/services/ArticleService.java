package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.DTO.ArticleDTO;
import avg.vnlaw.lawservice.DTO.ListTreeViewDTO;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface ArticleService {
    public Page<ArticleDTO> getArticleByChapter(String chapterId, Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<ArticleDTO> getArticleByFilter(Optional<String> subjectId, Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize);
    public ListTreeViewDTO getTreeViewByArticleId(String articleId);
}

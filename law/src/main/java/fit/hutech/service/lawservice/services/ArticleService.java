package fit.hutech.service.lawservice.services;

import fit.hutech.service.lawservice.DTO.ArticleDTO;
import fit.hutech.service.lawservice.DTO.ListTreeViewDTO;
import org.springframework.data.domain.Page;

import javax.swing.text.html.Option;
import java.util.Optional;

public interface ArticleService {
    public Page<ArticleDTO> getArticleByChapter(String chapterId,Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<ArticleDTO> getArticleByFilter(Optional<String> subjectId, Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize);
    public ListTreeViewDTO getTreeViewByArticleId(String articleId);
}

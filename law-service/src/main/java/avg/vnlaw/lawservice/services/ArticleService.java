package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseArticle;
import avg.vnlaw.lawservice.responses.ResponseListTree;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface ArticleService {
    public Page<ResponseArticle> getArticleByChapter(String chapterId, Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<ResponseArticle> getArticleByFilter(Optional<String> subjectId, Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize);
    public ResponseListTree getTreeViewByArticleId(String articleId);
}

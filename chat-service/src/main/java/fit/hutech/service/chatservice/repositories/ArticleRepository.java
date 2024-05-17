package fit.hutech.service.chatservice.repositories;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.models.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ArticleRepository extends JpaRepository<Article,String> {
    @Query("SELECT new fit.hutech.service.chatservice.DTO.ArticleDTO(a.id, a.name, a.content, a.index, a.vbqppl, a.vbqpplLink, a.order, a.subject.name, a.chapter.name, a.topic.name)" +
            " FROM Article a")
    List<ArticleDTO> getArticlesWithRelatedInfo();
}

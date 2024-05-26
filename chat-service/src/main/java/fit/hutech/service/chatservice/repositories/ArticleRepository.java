package fit.hutech.service.chatservice.repositories;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.models.Article;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ArticleRepository extends JpaRepository<Article,String> {
    @Query("SELECT new fit.hutech.service.chatservice.DTO.ArticleDTO(a.id, a.name, a.content, a.index, a.vbqppl, a.vbqpplLink, a.order, a.isEmbedded , a.subject.name, a.chapter.name, a.topic.name)" +
            " FROM Article a")
    List<ArticleDTO> getArticlesWithRelatedInfo();

    @Modifying
    @Query("UPDATE Article as a SET a.isEmbedded = :isEmbedded WHERE a.id = :id")
    @Transactional
    void updateArticle(String id, Boolean isEmbedded);
}

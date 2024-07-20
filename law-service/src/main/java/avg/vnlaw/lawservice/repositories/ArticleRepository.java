package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.responses.ResponseArticle;
import avg.vnlaw.lawservice.responses.ResponseArticleInt;
import avg.vnlaw.lawservice.entities.Article;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ArticleRepository extends JpaRepository<Article,String> {

    Page<ResponseArticleInt> findAllByChapter_IdOrderByOrder(String chapterId, Pageable pageable);
    List<ResponseArticleInt> findAllByChapter_IdOrderByOrder(String chapterId);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseArticle(a.id,a.name,a.content,a.index,a.vbqppl,a.vbqpplLink,a.order)" +
            " from Article a" +
            " where a.subject.id = ?1 and (?2 = '' OR a.name like %?2%)")
    Page<ResponseArticle> findAllFilterWithSubject(String subjectId , String name, Pageable pageable);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseArticle(a.id,a.name,a.content,a.index,a.vbqppl,a.vbqpplLink,a.order)" +
            " from Article a " +
            " where ?1 = '' or a.name like %?1%")
    Page<ResponseArticle> findAllFilter(String name, Pageable pageable);
}

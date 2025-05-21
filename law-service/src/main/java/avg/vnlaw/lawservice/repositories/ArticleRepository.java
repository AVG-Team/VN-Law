package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.dto.response.ArticleResponse;
import avg.vnlaw.lawservice.dto.response.ArticleIntResponse;
import avg.vnlaw.lawservice.entities.Article;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public  interface ArticleRepository extends JpaRepository<Article,String> {

    Page<ArticleIntResponse> findAllByChapter_IdOrderByOrder(String chapterId, Pageable pageable);
    List<ArticleIntResponse> findAllByChapter_IdOrderByOrder(String chapterId);

    @Query(" select new avg.vnlaw.lawservice.dto.response.ArticleResponse(a.id, a.name, a.content, a.index, a.vbqppl, a.vbqpplLink, a.order) " +
            " from Article a" +
            " where a.subject.id = ?1 and (?2 = '' OR a.name like %?2%)")
    Page<ArticleResponse> findAllFilterWithSubject(String subjectId , String name, Pageable pageable);

    @Query("select new avg.vnlaw.lawservice.dto.response.ArticleResponse(a.id, a.name, a.content, a.index, a.vbqppl, a.vbqpplLink, a.order)  " +
            " from Article a " +
            " where ?1 = '' or a.name like %?1%")
    Page<ArticleResponse> findAllFilter(String name, Pageable pageable);

    @Query("Select new avg.vnlaw.lawservice.dto.response.ArticleResponse(a.id, a.name, a.content, a.index, a.vbqppl, a.vbqpplLink, a.order)  " +
            "from Article a " +
            "where ?1 = '' or a.vbqppl like %?1%")
    Page<ArticleResponse> findAllFilterVbqppl(String name, Pageable pageable);

    @Query("Select a, s, c ,t From Article a " +
            "Join Subject s On a.subject.id = s.id " +
            "Join Chapter c On a.chapter.id = c.id " +
            "Join Topic t On a.topic.id = t.id ")
    List<Object[]> findAllArticlesForKafka();
}

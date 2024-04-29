package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.ArticleDTO;
import fit.hutech.service.lawservice.DTO.ArticleDTOINT;
import fit.hutech.service.lawservice.models.Article;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ArticleRepository extends JpaRepository<Article,String> {

    Page<ArticleDTO> findAllByChapter_IdOrderByOrder(String chapterId, Pageable pageable);
    List<ArticleDTOINT> findAllByChapter_IdOrderByOrder(String chapterId);

    @Query("select new fit.hutech.service.lawservice.DTO.ArticleDTO(a.id,a.name,a.content,a.index,a.vbqppl,a.vbqpplLink,a.order)" +
            " from Article a" +
            " where a.subject.id = ?1 and (?2 = '' OR a.name like %?2%)")
    Page<ArticleDTO> findAllFilterWithSubject(String subjectId ,String name, Pageable pageable);

    @Query("select new fit.hutech.service.lawservice.DTO.ArticleDTO(a.id,a.name,a.content,a.index,a.vbqppl,a.vbqpplLink,a.order)" +
            " from Article a " +
            " where ?1 = '' or a.name like %?1%")
    Page<ArticleDTO> findAllFilter(String name, Pageable pageable);
}

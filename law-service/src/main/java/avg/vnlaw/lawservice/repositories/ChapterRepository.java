package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.responses.ResponseChapter;
import avg.vnlaw.lawservice.entities.Chapter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter,String> {

    @Query("select new avg.vnlaw.lawservice.responses.ResponseChapter(c.id,c.name,c.index,c.order)" +
            " from Chapter c" +
            " where c.subject.id = ?1" +
            " order by  c.order")
    List<ResponseChapter> findChaptersBySubject(String idSubject);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseChapter(c.id,c.name,c.index,c.order)" +
            " from Chapter c " +
            " where c.name = '' or c.name like %?1%")
    Page<ResponseChapter> findAll(String name, Pageable pageable);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseChapter(c.id,c.name,c.index,c.order)" +
            " from Chapter c " +
            " where c.id = '' or c.id like %?1%")
    ResponseChapter findChapterById(String id);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseChapter(c.id,c.name,c.index,c.order)" +
            " from Chapter c ")
    List<ResponseChapter> findAllChapters();
}

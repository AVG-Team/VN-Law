package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.entities.Chapter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter,String> {

    @Query("SELECT new avg.vnlaw.lawservice.dto.response.ChapterResponse(c.id, c.name, c.index, c.order) " +
            "FROM Chapter c " +
            "WHERE c.subject.id = ?1 " +
            "ORDER BY c.order")
    List<ChapterResponse> findChaptersBySubject(String idSubject);

    @Query("SELECT new avg.vnlaw.lawservice.dto.response.ChapterResponse(c.id, c.name, c.index, c.order) " +
            "FROM Chapter c " +
            "WHERE c.name = '' OR c.name LIKE %?1%")
    Page<ChapterResponse> findAll(String name, Pageable pageable);

    @Query("SELECT new avg.vnlaw.lawservice.dto.response.ChapterResponse(c.id, c.name, c.index, c.order) " +
            "FROM Chapter c " +
            "WHERE c.id = '' OR c.id LIKE %?1%")
    ChapterResponse findChapterById(String id);

    @Query("SELECT new avg.vnlaw.lawservice.dto.response.ChapterResponse(c.id, c.name, c.index, c.order) " +
            "FROM Chapter c")
    List<ChapterResponse> findAllChapters();

}

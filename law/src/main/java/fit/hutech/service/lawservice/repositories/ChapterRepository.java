package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.ChapterDTO;
import fit.hutech.service.lawservice.models.Chapter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter,String> {

    @Query("select new fit.hutech.service.lawservice.DTO.ChapterDTO(c.id,c.name,c.index,c.order)" +
            " from Chapter c" +
            " where c.subject.id = ?1" +
            " order by  c.order")
    List<ChapterDTO> findChaptersBySubject(String idSubject);

    @Query("select new fit.hutech.service.lawservice.DTO.ChapterDTO(c.id,c.name,c.index,c.order)" +
            " from Chapter c " +
            " where c.name = '' or c.name like %?1%")
    Page<ChapterDTO> findAll(String name, Pageable pageable);
}

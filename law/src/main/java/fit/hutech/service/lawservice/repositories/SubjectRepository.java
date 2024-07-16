package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.SubjectDTO;
import fit.hutech.service.lawservice.models.Subject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, String> {
    @Query("select new fit.hutech.service.lawservice.DTO.SubjectDTO(p.id , p.name, p.order)" +
            " from Subject p " +
            " where p.topic.id = ?1 " +
            " order by  p.order ")
    List<SubjectDTO> findAllByTopic(String topicId);

    @Query("Select new fit.hutech.service.lawservice.DTO.SubjectDTO(p.id, p.name,p.order)" +
            " from Subject p " +
            " where p.name = '' or p.name like %?1%")
    Page<SubjectDTO> findAll(String name , Pageable pageable);
}

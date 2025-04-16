package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.entities.Subject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, String> {
    @Query("select new avg.vnlaw.lawservice.responses.ResponseSubject(p.id , p.name, p.order)" +
            " from Subject p " +
            " where p.topic.id = ?1 " +
            " order by  p.order ")
    List<SubjectResponse> findAllByTopic(String topicId);

    @Query("Select new avg.vnlaw.lawservice.responses.ResponseSubject(p.id, p.name,p.order)" +
            " from Subject p " +
            " where p.name = '' or p.name like %?1%")
    Page<SubjectResponse> findAllSubjects(String name , Pageable pageable);

    @Query("Select new avg.vnlaw.lawservice.responses.ResponseSubject(p.id, p.name,p.order)" +
            " from Subject p " +
            " where p.id = ?1")
    SubjectResponse findSubjectById(String id);

}

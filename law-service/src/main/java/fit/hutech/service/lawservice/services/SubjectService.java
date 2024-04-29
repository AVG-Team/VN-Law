package fit.hutech.service.lawservice.services;

import org.springframework.data.domain.Page;
import fit.hutech.service.lawservice.DTO.SubjectDTO;
import fit.hutech.service.lawservice.models.Subject;

import java.util.List;
import java.util.Optional;

public interface SubjectService {
    public String createSubject(Subject subject);
    public String updateSubject(Subject subject);
    public String deleteSubject(String subjectId);
    public Subject getSubject(String subjectId);
    public List<Subject> getAllSubjects();
    public List<SubjectDTO> getSubjectByTopic(String topicId);
    public Page<SubjectDTO> getAllSubject(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

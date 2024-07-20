package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseSubject;
import avg.vnlaw.lawservice.entities.Subject;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface SubjectService {
    public String createSubject(Subject subject);
    public String updateSubject(Subject subject);
    public String deleteSubject(String subjectId);
    public Subject getSubject(String subjectId);
    public List<Subject> getAllSubjects();
    public List<ResponseSubject> getSubjectByTopic(String topicId);
    public Page<ResponseSubject> getAllSubject(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

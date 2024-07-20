package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseSubject;
import avg.vnlaw.lawservice.entities.Subject;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface SubjectService {
    public ResponseSubject getSubject(String subjectId);
    public List<ResponseSubject> getSubjectByTopic(String topicId);
    public Page<ResponseSubject> getAllSubjects(Optional<String> name ,
                                               Optional<Integer> pageNo,
                                               Optional<Integer> pageSize);
}

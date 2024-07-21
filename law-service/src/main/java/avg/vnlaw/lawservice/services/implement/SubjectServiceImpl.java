package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.responses.ResponseSubject;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.SubjectRepository;
import avg.vnlaw.lawservice.services.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubjectServiceImpl implements SubjectService {

    final SubjectRepository subjectRepository;


    @Override
    public ResponseSubject getSubject(String subjectId) {
        if(subjectRepository.findById(subjectId).isEmpty()){
            throw new NotFoundException("Subject doesn't Exist");
        }
        return subjectRepository.findSubjectById(subjectId);
    }

    @Override
    public List<ResponseSubject> getSubjectByTopic(String topicId) {
        return subjectRepository.findAllByTopic(topicId);
    }

    @Override
    public Page<ResponseSubject> getAllSubjects(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(5));
        return subjectRepository.findAllSubjects(name.orElse(""), pageable);
    }
}

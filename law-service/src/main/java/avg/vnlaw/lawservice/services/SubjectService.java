package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.repositories.SubjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubjectService implements BaseService<SubjectResponse, String> {

    final SubjectRepository subjectRepository;

    public SubjectResponse getSubject(String subjectId) {
        if(subjectRepository.findById(subjectId).isEmpty()){
            throw new NotFoundException("Subject doesn't Exist");
        }
        return subjectRepository.findSubjectById(subjectId);
    }


    public List<SubjectResponse> getSubjectByTopic(String topicId) {
        return subjectRepository.findAllByTopic(topicId);
    }


    public Page<SubjectResponse> getAllSubjects(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(5));
        return subjectRepository.findAllSubjects(name.orElse(""), pageable);
    }

    @Override
    public Optional<SubjectResponse> findById(String id) {
        return Optional.empty();
    }

    @Override
    public SubjectResponse create(SubjectResponse entity) {
        return null;
    }

    @Override
    public SubjectResponse update(String id, SubjectResponse entity) {
        return null;
    }

    @Override
    public void delete(String id) {

    }
}

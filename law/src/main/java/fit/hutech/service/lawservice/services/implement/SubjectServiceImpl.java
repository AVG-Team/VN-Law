package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.DTO.SubjectDTO;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.models.Subject;
import fit.hutech.service.lawservice.repositories.SubjectRepository;
import fit.hutech.service.lawservice.services.SubjectService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class SubjectServiceImpl implements SubjectService {

    final SubjectRepository subjectRepository;

    public SubjectServiceImpl(SubjectRepository subjectRepository){
        this.subjectRepository = subjectRepository;
    }

    @Override
    public String createSubject(Subject subject) {
        subjectRepository.save(subject);
        return"Success";
    }

    @Override
    public String updateSubject(Subject subject) {
        return null;
    }

    @Override
    public String deleteSubject(String subjectId) {
        return null;
    }

    @Override
    public Subject getSubject(String subjectId) {
        if(subjectRepository.findById(subjectId).isEmpty()){
            throw new NotFoundException("Subject doesn't Exist");
        }
        return subjectRepository.findById(subjectId).get();
    }

    @Override
    public List<Subject> getAllSubjects() {
        if(subjectRepository.findAll().isEmpty())
            throw new NotFoundException("Subjects is empty");
        return subjectRepository.findAll();
    }

    @Override
    public List<SubjectDTO> getSubjectByTopic(String topicId) {
        return subjectRepository.findAllByTopic(topicId);
    }

    @Override
    public Page<SubjectDTO> getAllSubject(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(5));
        return subjectRepository.findAll(name.orElse(""), pageable);
    }
}

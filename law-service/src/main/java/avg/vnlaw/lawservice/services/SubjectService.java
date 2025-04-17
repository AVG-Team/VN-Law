package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.SubjectRequest;
import avg.vnlaw.lawservice.dto.response.SubjectResponse;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.SubjectMapper;
import avg.vnlaw.lawservice.repositories.SubjectRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubjectService implements BaseService<SubjectRequest, String, SubjectResponse> {

    private final SubjectRepository subjectRepository;
    private SubjectMapper subjectMapper;
    private final Logger log = LoggerFactory.getLogger(SubjectService.class);

    public SubjectResponse getSubject(String subjectId) {
        if(subjectRepository.findById(subjectId).isEmpty()){
            throw new AppException(ErrorCode.SUBJECT_IS_NOT_EXISTED);
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
        log.info("Find subject by id: {}", id);
        if(id == null || id.isEmpty()) throw new AppException(ErrorCode.ID_EMPTY);
        if(subjectRepository.findById(id).isEmpty()) throw new AppException(ErrorCode.SUBJECT_IS_NOT_EXISTED);

        Subject subject = subjectRepository.findById(id).get();

        return Optional.of(subjectMapper.toResponse(subject));
    }

    @Override
    public SubjectResponse create(SubjectRequest entity) {
        log.info("Create subject: {}", entity);
        if(entity == null ) throw new AppException(ErrorCode.SUBJECT_IS_NOT_EXISTED);
        subjectRepository.save(subjectMapper.toEntity(entity));

        return subjectMapper.requestToResponse(entity);
    }

    @Override
    public SubjectResponse update(SubjectRequest entity) {
        log.info("Update subject: {}", entity);
        if(entity == null ) throw new AppException(ErrorCode.SUBJECT_IS_NOT_EXISTED);
        subjectRepository.save(subjectMapper.toEntity(entity));
        return subjectMapper.requestToResponse(entity);
    }

    @Override
    public void delete(String id) {
        log.info("Delete subject: {}", id);
        if(id == null || id.isEmpty()) throw new AppException(ErrorCode.ID_EMPTY);
        subjectRepository.deleteById(id);
    }
}

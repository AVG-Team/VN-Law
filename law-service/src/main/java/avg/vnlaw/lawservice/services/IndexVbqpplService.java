package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.IndexVbqpplMapper;
import avg.vnlaw.lawservice.repositories.IndexVbqpplRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class IndexVbqpplService implements BaseService <IndexVbqpplRequest,Integer,IndexVbqpplResponse> {

    private final IndexVbqpplRepository indexVbqpplRepository;
    private final Logger log = LoggerFactory.getLogger(IndexVbqpplService.class);
    private IndexVbqpplMapper indexVbqpplMapper;



    public IndexVbqpplResponse getIndexVbqpplbyId(Integer id) {
        log.info("Get Index Vbqppl By Id {}", id);
        if(indexVbqpplRepository.findById(id).isEmpty()){
            throw new AppException(ErrorCode.INDEXVBQPPL_IS_NOT_EXISTED);
        }

        return indexVbqpplRepository.findIndexById(id);
    }


    public Page<IndexVbqpplResponse> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("Get All Index Vbqppl");
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return this.indexVbqpplRepository.findAllIndex(pageable);
    }

    @Override
    public Optional<IndexVbqpplResponse> findById(Integer id) {
        log.info("Find Index Vbqppl by Id {}", id);
        if(id == null) throw new AppException(ErrorCode.INDEXVBQPPL_IS_NOT_EXISTED);
        if(indexVbqpplRepository.findById(id).isEmpty())
            throw new AppException(ErrorCode.ARTICLE_IS_NOT_EXISTED);
        IndexVbqppl indexVbqppl = indexVbqpplRepository.findById(id).orElseThrow(
                () -> new AppException(ErrorCode.ARTICLE_IS_NOT_EXISTED)
        );
        return Optional.of(indexVbqpplMapper.toResponse(indexVbqppl));
    }

    @Override
    public IndexVbqpplResponse create(IndexVbqpplRequest entity) {
        log.info("Create Index Vbqppl {}", entity);
        if(entity == null) throw new AppException(ErrorCode.INDEXVBQPPL_NOT_FOUND);
        indexVbqpplRepository.save(indexVbqpplMapper.toEntity(entity));
        return indexVbqpplMapper.requestToResponse(entity);
    }

    @Override
    public IndexVbqpplResponse update(IndexVbqpplRequest entity) {
        log.info("Update Index Vbqppl {}", entity);
        if(entity == null) throw new AppException(ErrorCode.INDEXVBQPPL_NOT_FOUND);
        if(indexVbqpplRepository.findById(entity.getId()).isEmpty())
            throw new AppException(ErrorCode.ARTICLE_IS_NOT_EXISTED);
        indexVbqpplRepository.save(indexVbqpplMapper.toEntity(entity));
        return indexVbqpplMapper.requestToResponse(entity);
    }

    @Override
    public void delete(Integer id) {
        log.info("Delete Index Vbqppl {}", id);
        if(id == null) throw new AppException(ErrorCode.INDEXVBQPPL_NOT_FOUND);
        indexVbqpplRepository.deleteById(id);
    }
}

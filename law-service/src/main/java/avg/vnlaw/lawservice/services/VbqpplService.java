package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.VbqpplRequest;
import avg.vnlaw.lawservice.dto.response.VbqpplResponse;
import avg.vnlaw.lawservice.entities.Vbqppl;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.VbqpplMapper;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import avg.vnlaw.lawservice.repositories.VbqpplRepository;
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
public class VbqpplService implements BaseService<VbqpplRequest, Integer, VbqpplResponse> {


    private final VbqpplRepository vbqpplRepository;
    private final Logger log = LoggerFactory.getLogger(Logger.class);
    private VbqpplMapper vbqpplMapper;


    public Page<VbqpplResponse> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("get ALL vbqppl");
        if(vbqpplRepository.findAll().isEmpty())
            throw new AppException(ErrorCode.VBQPPL_EMPTY);
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return vbqpplRepository.findAllVbs(pageable);
    }


    public VbqpplResponse getVbqpplById(Integer idVbqppl) {
        log.info("get Vbqppl by id: {}", idVbqppl);
        if(vbqpplRepository.findById(idVbqppl).isEmpty()){
            throw new AppException(ErrorCode.VBQPPL_IS_NOT_EXISTED);
        }
        return vbqpplRepository.findVbById(idVbqppl);
    }



    public Page<VbqpplResponse> getVbqpplByType(Optional<String> type, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("get Vbqppl by type {}",type.orElse(""));
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(9));
        if(type.isPresent()){
            return vbqpplRepository.findAllByType(Optional.of(type.get()),pageable);
        }else {
            return vbqpplRepository.findAllByType(Optional.of(""),pageable);
        }

    }

    @Override
    public Optional<VbqpplResponse> findById(Integer id) {
        log.info("get Vbqppl by id: {}", id);
        if(vbqpplRepository.findById(id).isEmpty())
            throw new AppException(ErrorCode.VBQPPL_IS_NOT_EXISTED);
        Vbqppl vbqppl = vbqpplRepository.findById(id).get();
        return Optional.of(vbqpplMapper.toResponse(vbqppl));
    }

    @Override
    public VbqpplResponse create(VbqpplRequest entity) {
        log.info("create Vbqppl {}", entity);
        if(entity == null ) throw new AppException(ErrorCode.VBQPPL_NOT_FOUND);
        vbqpplRepository.save(vbqpplMapper.toEntity(entity));
        return vbqpplMapper.requestToResponse(entity);
    }

    @Override
    public VbqpplResponse update(VbqpplRequest entity) {
        log.info("update Vbqppl {}", entity);
        if(entity == null ) throw new AppException(ErrorCode.VBQPPL_NOT_FOUND);
        if(vbqpplRepository.findById(entity.getId()).isEmpty())
            throw new AppException(ErrorCode.VBQPPL_NOT_FOUND);
        vbqpplRepository.save(vbqpplMapper.toEntity(entity));
        return vbqpplMapper.requestToResponse(entity) ;
    }

    @Override
    public void delete(Integer id) {
        log.info("delete Vbqppl by id: {}", id);
        if(vbqpplRepository.findById(id).isEmpty())
            throw new AppException(ErrorCode.VBQPPL_NOT_FOUND);
        vbqpplRepository.deleteById(id);
    }
}

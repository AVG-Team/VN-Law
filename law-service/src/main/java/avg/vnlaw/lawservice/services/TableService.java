package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.entities.Tables;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.TableMapper;
import avg.vnlaw.lawservice.repositories.TableRepository;
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
public class TableService implements BaseService<TableRequest,Integer,TableResponse> {

    public final TableRepository tableRepository;
    public final Logger log = LoggerFactory.getLogger(TableService.class);
    public TableMapper tableMapper;

    public Page<TableResponse> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("Get all tables in database");
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllTable(pageable);
    }


    public Page<TableResponse> getAllTableByFilter(Optional<String> content, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("Get all tables in database by filter");
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllByFilter(content.orElse(""),pageable);
    }

    @Override
    public Optional<TableResponse> findById(Integer id) {
        log.info("Get table by id in database : {}",id);
        if(id == null) throw new AppException(ErrorCode.ID_EMPTY);
        if(tableRepository.findById(id).isEmpty())
            throw new AppException(ErrorCode.TABLE_IS_NOT_EXISTED);
        Tables table = tableRepository.findById(id).get();
        return Optional.of(tableMapper.toResponse(table));
    }

    @Override
    public TableResponse create(TableRequest entity) {
        log.info("Create table in database : {}",entity);
        if(entity == null ) throw new AppException(ErrorCode.TABLE_NOT_FOUND);
        tableRepository.save(tableMapper.toEntity(entity));
        return tableMapper.requestToResponse(entity);
    }

    @Override
    public TableResponse update(TableRequest entity) {
        log.info("Update table in database : {}",entity);
        if(entity == null ) throw new AppException(ErrorCode.TABLE_NOT_FOUND);
        if(entity.getId() == null ) throw new AppException(ErrorCode.TABLE_IS_NOT_EXISTED);
        tableRepository.save(tableMapper.toEntity(entity));
        return tableMapper.requestToResponse(entity);
    }

    @Override
    public void delete(Integer id) {
        log.info("Delete table in database : {}",id);
        if(id == null) throw new AppException(ErrorCode.ID_EMPTY);
        tableRepository.deleteById(id);
    }
}

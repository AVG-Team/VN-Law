package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.repositories.TableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TableService implements BaseService<TableRequest,Integer> {

    public final TableRepository tableRepository;


    public Page<TableResponse> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllTable(pageable);
    }


    public Page<TableResponse> getAllTableByFilter(Optional<String> content, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllByFilter(content.orElse(""),pageable);
    }

    @Override
    public Optional<TableRequest> findById(Integer id) {
        return Optional.empty();
    }

    @Override
    public TableRequest create(TableRequest entity) {
        return null;
    }

    @Override
    public TableRequest update(Integer id, TableRequest entity) {
        return null;
    }

    @Override
    public void delete(Integer id) {

    }
}

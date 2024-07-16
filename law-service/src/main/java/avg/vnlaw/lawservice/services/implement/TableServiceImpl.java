package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.DTO.TableDTO;
import avg.vnlaw.lawservice.repositories.TableRepository;
import avg.vnlaw.lawservice.services.TableService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TableServiceImpl implements TableService {

    public final TableRepository tableRepository;

    @Override
    public Page<TableDTO> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllTable(pageable);
    }

    @Override
    public Page<TableDTO> getAllTableByFilter(Optional<String> content, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllByFilter(content.orElse(""),pageable);
    }
}

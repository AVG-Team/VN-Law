package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.responses.ResponseTable;
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
    public Page<ResponseTable> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllTable(pageable);
    }

    @Override
    public Page<ResponseTable> getAllTableByFilter(Optional<String> content, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return tableRepository.findAllByFilter(content.orElse(""),pageable);
    }
}

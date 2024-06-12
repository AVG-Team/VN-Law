package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.DTO.TableDTO;
import fit.hutech.service.lawservice.models.Tables;
import fit.hutech.service.lawservice.repositories.TableRepository;
import fit.hutech.service.lawservice.services.TableService;
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

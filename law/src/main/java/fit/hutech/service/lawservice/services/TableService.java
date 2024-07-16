package fit.hutech.service.lawservice.services;

import fit.hutech.service.lawservice.DTO.TableDTO;
import fit.hutech.service.lawservice.models.Tables;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface TableService {
    public Page<TableDTO> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<TableDTO> getAllTableByFilter(Optional<String> content,Optional<Integer> pageNo, Optional<Integer> pageSize);
}

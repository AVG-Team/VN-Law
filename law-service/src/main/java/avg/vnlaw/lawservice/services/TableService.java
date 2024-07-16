package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.DTO.TableDTO;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface TableService {
    public Page<TableDTO> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<TableDTO> getAllTableByFilter(Optional<String> content,Optional<Integer> pageNo, Optional<Integer> pageSize);
}

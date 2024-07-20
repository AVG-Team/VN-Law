package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseTable;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface TableService {
    public Page<ResponseTable> getAllTable(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Page<ResponseTable> getAllTableByFilter(Optional<String> content, Optional<Integer> pageNo, Optional<Integer> pageSize);
}

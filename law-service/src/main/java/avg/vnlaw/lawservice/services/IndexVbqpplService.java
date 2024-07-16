package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.entities.IndexVbqppl;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface IndexVbqpplService {
    public IndexVbqppl getIndexVbqpplbyId(Integer id);
    public Page<IndexVbqppl> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);

}

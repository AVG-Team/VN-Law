package fit.hutech.service.lawservice.services;

import fit.hutech.service.lawservice.models.IndexVbqppl;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface IndexVbqpplService {
    public IndexVbqppl getIndexVbqpplbyId(Integer id);
    public Page<IndexVbqppl> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);

}

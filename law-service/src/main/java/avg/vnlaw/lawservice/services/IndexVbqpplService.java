package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.responses.ResponseIndexVbqppl;
import org.springframework.data.domain.Page;

import java.util.Optional;

public interface IndexVbqpplService {
    public ResponseIndexVbqppl getIndexVbqpplbyId(Integer id);
    public Page<ResponseIndexVbqppl> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);

}

package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseVbqppl;
import avg.vnlaw.lawservice.entities.Vbqppl;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface VbqpplService{
    public Page<ResponseVbqppl> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public ResponseVbqppl getVbqpplById(Integer idVbqppl);
    public Page<ResponseVbqppl> getVbqpplByType(Optional<String> type ,
                                                Optional<Integer> pageNo,
                                                Optional<Integer> pageSize);
}

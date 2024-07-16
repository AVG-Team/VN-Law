package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.DTO.VbqpplDTO;
import avg.vnlaw.lawservice.entities.Vbqppl;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface VbqpplService{
    public Page<Vbqppl> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Vbqppl getVbqpplById(Integer idVbqppl);
    public List<Vbqppl> getAll();
    public Page<VbqpplDTO> getVbqpplByType(Optional<String> type , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

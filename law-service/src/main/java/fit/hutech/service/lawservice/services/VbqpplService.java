package fit.hutech.service.lawservice.services;

import fit.hutech.service.lawservice.models.Vbqppl;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface VbqpplService{
    public Page<Vbqppl> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize);
    public Vbqppl getVbqpplById(Integer idVbqppl);
}

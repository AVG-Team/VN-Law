package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.DTO.VbqpplDTO;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.models.Vbqppl;
import fit.hutech.service.lawservice.repositories.VbqpplRepository;
import fit.hutech.service.lawservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VbqpplServiceImpl implements VbqpplService {

    private final VbqpplRepository vbqpplRepository;

    @Override
    public Page<Vbqppl> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return vbqpplRepository.findAll(pageable);
    }

    @Override
    public Vbqppl getVbqpplById(Integer idVbqppl) {
        Optional<Vbqppl> optionalVbqppl = Optional.ofNullable(vbqpplRepository.findById(idVbqppl).orElseThrow(
                () -> new NotFoundException("Not Found")
        ));
        return optionalVbqppl.orElse(null);
    }

    @Override
    public List<Vbqppl> getAll() {
        return vbqpplRepository.findAll();
    }

    @Override
    public Page<VbqpplDTO> getVbqpplByType(Optional<String> type, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(9));
        if(type.isPresent()){
            return vbqpplRepository.findAllByType(Optional.of(type.get()),pageable);
        }else {
            return vbqpplRepository.findAllByType(Optional.of(""),pageable);
        }

    }
}

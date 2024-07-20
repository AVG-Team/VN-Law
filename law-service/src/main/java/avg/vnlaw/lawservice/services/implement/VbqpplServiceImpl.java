package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.responses.ResponseVbqppl;
import avg.vnlaw.lawservice.entities.Vbqppl;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.VbqpplRepository;
import avg.vnlaw.lawservice.services.VbqpplService;
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
    public Page<ResponseVbqppl> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return vbqpplRepository.findAllVbs(pageable);
    }

    @Override
    public ResponseVbqppl getVbqpplById(Integer idVbqppl) {
        if(vbqpplRepository.findById(idVbqppl).isEmpty()){
            throw new NotFoundException("Not Found");
        }
        return vbqpplRepository.findVbById(idVbqppl);
    }


    @Override
    public Page<ResponseVbqppl> getVbqpplByType(Optional<String> type, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(9));
        if(type.isPresent()){
            return vbqpplRepository.findAllByType(Optional.of(type.get()),pageable);
        }else {
            return vbqpplRepository.findAllByType(Optional.of(""),pageable);
        }

    }
}

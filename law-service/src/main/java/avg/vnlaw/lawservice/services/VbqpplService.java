package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.response.VbqpplResponse;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.repositories.VbqpplRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VbqpplService {


    private final VbqpplRepository vbqpplRepository;


    public Page<VbqpplResponse> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return vbqpplRepository.findAllVbs(pageable);
    }


    public VbqpplResponse getVbqpplById(Integer idVbqppl) {
        if(vbqpplRepository.findById(idVbqppl).isEmpty()){
            throw new AppException(ErrorCode.VBQPPL_IS_NOT_EXISTED);
        }
        return vbqpplRepository.findVbById(idVbqppl);
    }



    public Page<VbqpplResponse> getVbqpplByType(Optional<String> type, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(9));
        if(type.isPresent()){
            return vbqpplRepository.findAllByType(Optional.of(type.get()),pageable);
        }else {
            return vbqpplRepository.findAllByType(Optional.of(""),pageable);
        }

    }
}

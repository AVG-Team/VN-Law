package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.response.VbqpplResponse;
import avg.vnlaw.lawservice.repositories.VbqpplRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VbqpplService implements BaseService<VbqpplResponse, Integer> {


    private final VbqpplRepository vbqpplRepository;


    public Page<VbqpplResponse> getAllVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return vbqpplRepository.findAllVbs(pageable);
    }


    public VbqpplResponse getVbqpplById(Integer idVbqppl) {
        if(vbqpplRepository.findById(idVbqppl).isEmpty()){
            throw new NotFoundException("Not Found");
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

    @Override
    public Optional<VbqpplResponse> findById(Integer id) {
        return Optional.empty();
    }

    @Override
    public VbqpplResponse create(VbqpplResponse entity) {
        return null;
    }

    @Override
    public VbqpplResponse update(Integer id, VbqpplResponse entity) {
        return null;
    }

    @Override
    public void delete(Integer id) {

    }
}

package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.models.IndexVbqppl;
import fit.hutech.service.lawservice.models.Vbqppl;
import fit.hutech.service.lawservice.repositories.IndexVbqpplRepository;
import fit.hutech.service.lawservice.services.IndexVbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class IndexVbqpplServiceImpl implements IndexVbqpplService {

    private final IndexVbqpplRepository indexVbqpplRepository;

    @Override
    public IndexVbqppl getIndexVbqpplbyId(Integer id) {
        Optional<IndexVbqppl> optionalIndexVbqppl = Optional.ofNullable(indexVbqpplRepository.findById(id).orElseThrow(
                () -> new NotFoundException("Not Found")
        ));
        return optionalIndexVbqppl.orElse(null);
    }

    @Override
    public Page<IndexVbqppl> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return this.indexVbqpplRepository.findAll(pageable);
    }

    public IndexVbqppl getIndex(Integer id){
        return indexVbqpplRepository.findById(id).get();
    }
}

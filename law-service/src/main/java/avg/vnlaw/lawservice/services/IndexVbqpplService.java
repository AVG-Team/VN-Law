package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.repositories.IndexVbqpplRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class IndexVbqpplService  {

    private final IndexVbqpplRepository indexVbqpplRepository;


    public IndexVbqpplResponse getIndexVbqpplbyId(Integer id) {

        if(indexVbqpplRepository.findById(id).isEmpty()){
            throw new AppException(ErrorCode.INDEXVBQPPL_IS_NOT_EXISTED);
        }

        return indexVbqpplRepository.findIndexById(id);
    }


    public Page<IndexVbqpplResponse> getAllIndexVbqppl(Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        return this.indexVbqpplRepository.findAllIndex(pageable);
    }
}

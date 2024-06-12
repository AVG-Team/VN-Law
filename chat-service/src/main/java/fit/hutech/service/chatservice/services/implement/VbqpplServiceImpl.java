package fit.hutech.service.chatservice.services.implement;

import fit.hutech.service.chatservice.services.VbqpplService;
import fit.hutech.service.chatservice.models.Vbqppl;
import fit.hutech.service.chatservice.repositories.VbqpplRepository;
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
    public List<Vbqppl> getAll() {
        return vbqpplRepository.findAll();
    }


}

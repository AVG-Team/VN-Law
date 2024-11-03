package fit.hutech.service.chatservice.services;

import fit.hutech.service.chatservice.models.Vbqppl;
import fit.hutech.service.chatservice.repositories.VbqpplRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VbqpplService {

    private final VbqpplRepository vbqpplRepository;

    public List<Vbqppl> getAll() {
        return vbqpplRepository.findAll();
    }


}

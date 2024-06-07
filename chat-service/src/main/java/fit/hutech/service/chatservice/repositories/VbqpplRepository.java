package fit.hutech.service.chatservice.repositories;

import fit.hutech.service.chatservice.models.Vbqppl;
import org.jetbrains.annotations.NotNull;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VbqpplRepository extends JpaRepository<Vbqppl,Integer> {
    public List<Vbqppl> findAll();
}

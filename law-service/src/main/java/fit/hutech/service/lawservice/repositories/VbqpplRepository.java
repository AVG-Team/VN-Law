package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.models.Vbqppl;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VbqpplRepository extends JpaRepository<Vbqppl,Integer> {
}

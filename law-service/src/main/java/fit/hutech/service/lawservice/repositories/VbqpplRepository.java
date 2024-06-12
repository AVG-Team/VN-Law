package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.VbqpplDTO;
import fit.hutech.service.lawservice.models.Vbqppl;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VbqpplRepository extends JpaRepository<Vbqppl,Integer> {

    @Query("select new fit.hutech.service.lawservice.DTO.VbqpplDTO(v.id,v.content,v.name,v.number,v.type,v.html)" +
            "from Vbqppl v " +
            "where ( v.type like %?1%  or ?1 = '') and v.html is not null")
    public Page<VbqpplDTO>findAllByType (Optional<String> type, Pageable pageable);


}

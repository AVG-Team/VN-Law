package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.models.Vbqppl;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VbqpplRepository extends JpaRepository<Vbqppl,Integer> {

    @Query("select new fit.hutech.service.lawservice.DTO.VbqpplDTO(v.id,v.content,v.name,v.number,v.type,v.html)" +
            "from Vbqppl v " +
            "where v.type like %?1% or ?1 = '' ")
    public List<Vbqppl>findAllByType (String type, Pageable pageable);


    @Query("select new fit.hutech.service.lawservice.DTO.VbqpplDTO(v.id,v.content,v.name,v.number,v.type,v.html)" +
            "from Vbqppl v " +
            "where v.name like %?1% or ?1 = '' ")
    public List<Vbqppl> findAllByName(String name, Pageable pageable);
}

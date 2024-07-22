package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.responses.ResponseIndexVbqppl;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface IndexVbqpplRepository extends JpaRepository<IndexVbqppl,Integer> {

    @Query("select new avg.vnlaw.lawservice.responses.ResponseIndexVbqppl(i.id,i.content,i.type,i.name,i.indexVbqppl.id,i.vbqppl.id) " +
            "from IndexVbqppl i " +
            "where i.id = ?1")
    public ResponseIndexVbqppl findIndexById(Integer id);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseIndexVbqppl(i.id,i.content,i.type,i.name,i.indexVbqppl.id,i.vbqppl.id)" +
            "from IndexVbqppl i ")
    public Page<ResponseIndexVbqppl> findAllIndex(Pageable pageable);
}

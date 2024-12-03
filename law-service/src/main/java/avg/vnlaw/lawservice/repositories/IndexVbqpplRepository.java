package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface IndexVbqpplRepository extends JpaRepository<IndexVbqppl,Integer> {

    @Query("select new avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse(i.id,i.content,i.type,i.name,i.indexVbqppl.id,i.vbqppl.id) " +
            "from IndexVbqppl i " +
            "where i.id = ?1")
    public IndexVbqpplResponse findIndexById(Integer id);

    @Query("select new avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse(i.id,i.content,i.type,i.name,i.indexVbqppl.id,i.vbqppl.id)" +
            "from IndexVbqppl i ")
    public Page<IndexVbqpplResponse> findAllIndex(Pageable pageable);
}

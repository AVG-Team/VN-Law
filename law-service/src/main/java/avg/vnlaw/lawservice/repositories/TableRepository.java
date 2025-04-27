package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.entities.Tables;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableRepository extends JpaRepository<Tables,Integer> {

    public List<TableResponse> findAllByArticle_IdOrderByArticle(String articleId);

    @Query(" select new avg.vnlaw.lawservice.dto.response.TableResponse(t.id,t.html)" +
            " from Tables t " +
            " where ?1 = '' OR t.html like %?1%")
    public Page<TableResponse> findAllByFilter(String content, Pageable pageable);

    @Query(" select new avg.vnlaw.lawservice.dto.response.TableResponse(t.id,t.html)" +
            " from Tables t ")
    public Page<TableResponse> findAllTable(Pageable pageable);
}

package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.responses.ResponseTable;
import avg.vnlaw.lawservice.entities.Tables;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableRepository extends JpaRepository<Tables,String> {

    public List<ResponseTable> findAllByArticle_IdOrderByArticle(String articleId);

    @Query(" select new avg.vnlaw.lawservice.responses.ResponseTable(t.id,t.html)" +
            " from Tables t " +
            " where ?1 = '' OR t.html like %?1%")
    public Page<ResponseTable> findAllByFilter(String content, Pageable pageable);

    @Query(" select new avg.vnlaw.lawservice.responses.ResponseTable(t.id,t.html)" +
            " from Tables t ")
    public Page<ResponseTable> findAllTable(Pageable pageable);
}

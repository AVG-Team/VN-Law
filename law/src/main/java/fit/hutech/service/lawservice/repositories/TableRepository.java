package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.TableDTO;
import fit.hutech.service.lawservice.models.Tables;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TableRepository extends JpaRepository<Tables,String> {

    public List<TableDTO> findAllByArticle_IdOrderByArticle(String articleId);

    @Query(" select new fit.hutech.service.lawservice.DTO.TableDTO(t.id,t.html)" +
            " from Tables t " +
            " where ?1 = '' OR t.html like %?1%")
    public Page<TableDTO> findAllByFilter(String content, Pageable pageable);

    @Query(" select new fit.hutech.service.lawservice.DTO.TableDTO(t.id,t.html)" +
            " from Tables t ")
    public Page<TableDTO> findAllTable(Pageable pageable);
}

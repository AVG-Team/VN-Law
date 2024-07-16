package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.DTO.FileDTO;
import fit.hutech.service.lawservice.models.Files;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileRepository extends JpaRepository<Files,String> {

    public List<FileDTO> findAllByArticle_IdOrderByArticle(String articleId);
}

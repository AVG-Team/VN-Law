package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.DTO.FileDTO;
import avg.vnlaw.lawservice.entities.Files;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileRepository extends JpaRepository<Files,String> {

    public List<FileDTO> findAllByArticle_IdOrderByArticle(String articleId);
}

package fit.hutech.service.chatservice.repositories;

import fit.hutech.service.chatservice.DTO.FileDTO;
import fit.hutech.service.chatservice.models.Files;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileRepository extends JpaRepository<Files,String> {
    public List<FileDTO> findAllByArticle_IdOrderByArticle(String articleId);
}

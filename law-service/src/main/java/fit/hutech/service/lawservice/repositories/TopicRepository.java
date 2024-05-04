package fit.hutech.service.lawservice.repositories;

import fit.hutech.service.lawservice.models.Topic;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TopicRepository extends JpaRepository<Topic, String> {
}

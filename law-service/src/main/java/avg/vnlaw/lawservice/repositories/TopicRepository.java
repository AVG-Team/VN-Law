package avg.vnlaw.lawservice.repositories;


import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.responses.ResponseTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TopicRepository extends JpaRepository<Topic, String> {

    @Query("select new avg.vnlaw.lawservice.responses.ResponseTopic(t.id,t.name,t.order) from Topic t where t.id = ?1")
    public ResponseTopic findTopicById(String id);

    @Query("select new avg.vnlaw.lawservice.responses.ResponseTopic(t.id,t.name,t.order) from Topic t")
    public List<ResponseTopic> findAllTopics();
}

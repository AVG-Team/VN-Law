package avg.vnlaw.lawservice.elastic.repositories;

import avg.vnlaw.lawservice.elastic.documents.TopicDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TopicDocumentRepository extends ElasticsearchRepository<TopicDocument,String> {
}

package avg.vnlaw.lawservice.elastic.repositories;

import avg.vnlaw.lawservice.elastic.documents.VbqpplDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VbqpplDocumentRepository extends ElasticsearchRepository<VbqpplDocument,String> {
}

package avg.vnlaw.lawservice.elastic.repositories;

import avg.vnlaw.lawservice.elastic.documents.SubjectDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SubjectDocumentRepository extends ElasticsearchRepository<SubjectDocument,String> {
}

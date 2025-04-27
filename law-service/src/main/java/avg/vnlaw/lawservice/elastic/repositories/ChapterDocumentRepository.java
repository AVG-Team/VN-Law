package avg.vnlaw.lawservice.elastic.repositories;

import avg.vnlaw.lawservice.elastic.documents.ChapterDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChapterDocumentRepository extends ElasticsearchRepository<ChapterDocument,String> {
}

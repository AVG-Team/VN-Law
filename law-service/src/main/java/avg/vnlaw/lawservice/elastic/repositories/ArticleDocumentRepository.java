package avg.vnlaw.lawservice.elastic.repositories;

import avg.vnlaw.lawservice.elastic.documents.ArticleDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.data.elasticsearch.repository.query.ElasticsearchEntityMetadata;
import org.springframework.stereotype.Repository;

@Repository
public interface ArticleDocumentRepository extends ElasticsearchRepository<ArticleDocument,String> {
}

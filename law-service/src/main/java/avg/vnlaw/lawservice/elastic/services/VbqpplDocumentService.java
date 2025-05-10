package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.TopicDocument;
import avg.vnlaw.lawservice.elastic.documents.VbqpplDocument;
import avg.vnlaw.lawservice.elastic.repositories.TopicDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.VbqpplDocumentRepository;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.entities.Vbqppl;
import co.elastic.clients.elasticsearch._types.query_dsl.MatchQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import lombok.RequiredArgsConstructor;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VbqpplDocumentService {

    private final VbqpplDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Vbqppl entity) {
        VbqpplDocument vbqpplDocument = VbqpplDocument.builder()
                .id(entity.getVbqppl_id())
                .html(entity.getHtml())
                .content(entity.getContent())
                .type(entity.getType())
                .build();

        repository.save(vbqpplDocument);
    }

    public List<VbqpplDocument> search(String keyword) {
        Query matchQuery = MatchQuery.of(m -> m
                .field("html")
                .field("content")
                .field("type")
                .query(keyword)
                .fuzziness("AUTO")
        )._toQuery();

        NativeQuery query = NativeQuery.builder()
                .withQuery(matchQuery)
                .build();

        SearchHits<VbqpplDocument> hits = elasticsearchOperations.search(query,VbqpplDocument.class);
        return hits.getSearchHits().stream()
                .map(hit -> hit.getContent())
                .toList();

    }
}

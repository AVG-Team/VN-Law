package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.SubjectDocument;
import avg.vnlaw.lawservice.elastic.documents.TopicDocument;
import avg.vnlaw.lawservice.elastic.repositories.SubjectDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.TopicDocumentRepository;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
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
public class TopicDocumentService {

    private final TopicDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Topic entity) {
        TopicDocument topicDocument = TopicDocument.builder()
                .id(entity.getId())
                .name(entity.getName())
                .order(entity.getOrder())
                .build();

        repository.save(topicDocument);
    }

    public List<TopicDocument> search(String keyword) {
        Query matchQuery = MatchQuery.of(m -> m
                .field("name")
                .query(keyword)
                .fuzziness("AUTO")
        )._toQuery();

        NativeQuery query = NativeQuery.builder()
                .withQuery(matchQuery)
                .build();

        SearchHits<TopicDocument> hits = elasticsearchOperations.search(query,TopicDocument.class);
        return hits.getSearchHits().stream()
                .map(hit -> hit.getContent())
                .toList();

    }
}

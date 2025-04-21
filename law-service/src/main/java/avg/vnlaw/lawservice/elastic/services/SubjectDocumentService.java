package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.ArticleDocument;
import avg.vnlaw.lawservice.elastic.documents.SubjectDocument;
import avg.vnlaw.lawservice.elastic.repositories.ArticleDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.SubjectDocumentRepository;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Subject;
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
public class SubjectDocumentService {

    private final SubjectDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Subject entity) {
         SubjectDocument subjectDocument = SubjectDocument.builder()
                .id(entity.getId())
                .name(entity.getName())
                .order(entity.getOrder())
                 .topicId(entity.getTopic().getId())
                .build();

        repository.save(subjectDocument);
    }

    public List<SubjectDocument> search(String keyword) {
        Query matchQuery = MatchQuery.of(m -> m
                .field("name")
                .query(keyword)
                .fuzziness("AUTO")
        )._toQuery();

        NativeQuery query = NativeQuery.builder()
                .withQuery(matchQuery)
                .build();

        SearchHits<SubjectDocument> hits = elasticsearchOperations.search(query,SubjectDocument.class);
        return hits.getSearchHits().stream()
                .map(hit -> hit.getContent())
                .toList();

    }
}

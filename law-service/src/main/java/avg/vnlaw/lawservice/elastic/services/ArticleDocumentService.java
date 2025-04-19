package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.ArticleDocument;
import avg.vnlaw.lawservice.elastic.repositories.ArticleDocumentRepository;
import avg.vnlaw.lawservice.entities.Article;
import co.elastic.clients.elasticsearch._types.query_dsl.MatchQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleDocumentService {

    private final ArticleDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Article entity) {
        ArticleDocument articleDocument = ArticleDocument.builder()
                .id(entity.getId())
                .name(entity.getName())
                .order(entity.getOrder())
                .content(entity.getContent())
                .index(entity.getIndex())
                .chapterId(entity.getChapter().getId())
                .effectiveDate(entity.getEffectiveDate())
                .topicId(entity.getTopic().getId())
                .subjectId(entity.getSubject().getId())
                .vbqppl(entity.getVbqppl())
                .vbqpplLink(entity.getVbqpplLink())
                .build();

        repository.save(articleDocument);
    }

    public List<ArticleDocument> search(String keyword) {
        Query matchQuery = MatchQuery.of(m -> m
                .field("name")
                .field("order")
                .field("content")
                .field("index")
                .field("vbqppl")
                .query(keyword)
                .fuzziness("AUTO")
        )._toQuery();

        NativeQuery query = NativeQuery.builder()
                .withQuery(matchQuery)
                .build();

        SearchHits<ArticleDocument> hits = elasticsearchOperations.search(query,ArticleDocument.class);
        return hits.getSearchHits().stream()
                .map(hit -> hit.getContent())
                .toList();

    }
}

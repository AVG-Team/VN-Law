package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.ArticleDocument;
import avg.vnlaw.lawservice.elastic.documents.ChapterDocument;
import avg.vnlaw.lawservice.elastic.repositories.ArticleDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.ChapterDocumentRepository;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
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
public class ChapterDocumentService {

    private final ChapterDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Chapter entity) {
        ChapterDocument chapterDocument = ChapterDocument.builder()
                .id(entity.getId())
                .name(entity.getName())
                .order(entity.getOrder())
                .subjectId(entity.getId())
                .index(entity.getIndex())
                .build();

        repository.save(chapterDocument);
    }

    public List<ChapterDocument> search(String keyword) {
        Query matchQuery = MatchQuery.of(m -> m
                .field("name")
                .query(keyword)
                .fuzziness("AUTO")
        )._toQuery();

        NativeQuery query = NativeQuery.builder()
                .withQuery(matchQuery)
                .build();

        SearchHits<ChapterDocument> hits = elasticsearchOperations.search(query,ChapterDocument.class);
        return hits.getSearchHits().stream()
                .map(hit -> hit.getContent())
                .toList();

    }
}

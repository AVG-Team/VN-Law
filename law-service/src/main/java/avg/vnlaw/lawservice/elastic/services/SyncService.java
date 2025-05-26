package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.*;
import avg.vnlaw.lawservice.elastic.repositories.*;
import avg.vnlaw.lawservice.entities.*;
import avg.vnlaw.lawservice.repositories.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Retryable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SyncService {
    private final TopicDocumentRepository topicDocumentRepository;
    private final SubjectDocumentRepository subjectDocumentRepository;
    private final ChapterDocumentRepository chapterDocumentRepository;
    private final ArticleDocumentRepository articleDocumentRepository;
    private final VbqpplDocumentRepository vbqpplDocumentRepository; // Thêm repository Elasticsearch
    private final TopicRepository topicRepository;
    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final ArticleRepository articleRepository;
    private final VbqpplRepository vbqpplRepository; // Thêm repository JPA
    private final Logger logger = LoggerFactory.getLogger(SyncService.class);
    private static final int PAGESIZES = 20;

    @Async
    public void syncAllDocumentsToElasticSearch() {
        logger.info("Starting sync all document to ElasticSearch");
        syncEntityToElasticSearch(
                topicRepository, topicDocumentRepository, this::topicToElasticSearchDoc, "Topic"
        );
        syncEntityToElasticSearch(
                subjectRepository, subjectDocumentRepository, this::subjectToElasticSearchDoc, "Subject"
        );
        syncEntityToElasticSearch(
                chapterRepository, chapterDocumentRepository, this::chapterToElasticSearchDoc, "Chapter"
        );
        syncEntityToElasticSearch(
                articleRepository, articleDocumentRepository, this::articleToElasticSearchDoc, "Article"
        );
        syncEntityToElasticSearch(
                vbqpplRepository, vbqpplDocumentRepository, this::vbqpplToElasticSearchDoc, "Vbqppl" // Thêm đồng bộ Vbqppl
        );
        logger.info("Finished sync all document to ElasticSearch");
    }

    @Async
    public void syncVbqpplDocumentsToElasticSearch() {
        logger.info("Starting sync Vbqppl documents to ElasticSearch");
        syncEntityToElasticSearch(vbqpplRepository, vbqpplDocumentRepository, this::vbqpplToElasticSearchDoc, "Vbqppl");
        logger.info("Finished sync Vbqppl documents to ElasticSearch");
    }

    @Retryable(value = { DataAccessResourceFailureException.class },
            maxAttempts = 5,
            backoff = @Backoff(delay = 1000))
    protected <E, D> void syncEntityToElasticSearch(
            JpaRepository<E, ?> jpaRepository,
            ElasticsearchRepository<D, ?> esRepository,
            Function<E, D> mapper,
            String entityName
    ) {
        try {
            logger.info("Starting sync {} to ElasticSearch", entityName);
            int page = 0;
            Page<E> entities;
            do {
                entities = jpaRepository.findAll(PageRequest.of(page, PAGESIZES));
                List<D> documents = entities.stream()
                        .map(mapper).collect(Collectors.toList());
                documents.forEach(doc -> {
                    try {
                        String json = new ObjectMapper().writeValueAsString(doc);
                        logger.info("Document size for {}: {} bytes", entityName, json.length());
                    } catch (Exception e) {
                        logger.error("Error calculating document size", e);
                    }
                });
                esRepository.saveAll(documents);
                page++;
            } while (!entities.isLast());
            logger.info("✔ Synced {} {}s to Elasticsearch", entities.getTotalElements(), entityName);
        } catch (Exception e) {
            logger.error("Failed to sync {} to ElasticSearch: {}", entityName, e.getMessage(), e);
        }
    }

    private TopicDocument topicToElasticSearchDoc(Topic topic) {
        return TopicDocument.builder()
                .id(topic.getId())
                .name(topic.getName())
                .order(topic.getOrder())
                .build();
    }

    private SubjectDocument subjectToElasticSearchDoc(Subject subject) {
        return SubjectDocument.builder()
                .id(subject.getId())
                .name(subject.getName())
                .order(subject.getOrder())
                .topicId(subject.getTopic().getId())
                .build();
    }

    private ChapterDocument chapterToElasticSearchDoc(Chapter chapter) {
        return ChapterDocument.builder()
                .id(chapter.getId())
                .name(chapter.getName())
                .index(chapter.getIndex())
                .order(chapter.getOrder())
                .subjectId(chapter.getSubject().getId())
                .build();
    }

    private ArticleDocument articleToElasticSearchDoc(Article article) {
        return ArticleDocument.builder()
                .id(article.getId())
                .name(article.getName())
                .order(article.getOrder())
                .vbqppl(article.getVbqppl())
                .vbqpplLink(article.getVbqpplLink())
                .content(article.getContent())
                .effectiveDate(article.getEffectiveDate())
                .chapterId(article.getChapter().getId())
                .subjectId(article.getSubject().getId())
                .topicId(article.getTopic().getId())
                .build();
    }

    private VbqpplDocument vbqpplToElasticSearchDoc(Vbqppl vbqppl) {
        return VbqpplDocument.builder()
                .id(vbqppl.getVbqppl_id())
                .html(vbqppl.getHtml())
                .content(vbqppl.getContent())
                .type(vbqppl.getType())
                .number(vbqppl.getNumber())
                .effectiveDate(vbqppl.getEffectiveDate())
                .effectiveEndDate(vbqppl.getEffectiveEndDate())
                .statusCode(vbqppl.getStatusCode())
                .issueDate(vbqppl.getIssueDate())
                .issuer(vbqppl.getIssuer())
                .title(vbqppl.getTitle())
                .build();
    }
}
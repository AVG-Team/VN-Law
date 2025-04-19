package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.ArticleDocument;
import avg.vnlaw.lawservice.elastic.documents.ChapterDocument;
import avg.vnlaw.lawservice.elastic.documents.SubjectDocument;
import avg.vnlaw.lawservice.elastic.documents.TopicDocument;
import avg.vnlaw.lawservice.elastic.repositories.ArticleDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.ChapterDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.SubjectDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.TopicDocumentRepository;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.ChapterRepository;
import avg.vnlaw.lawservice.repositories.SubjectRepository;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.data.jpa.repository.JpaRepository;
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
    private final TopicRepository topicRepository;
    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final ArticleRepository articleRepository;
    private final Logger logger = LoggerFactory.getLogger(SyncService.class);
    private static final int PAGESIZES = 1000;

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
        logger.info("Finished sync all document to ElasticSearch");
    }

    // Sync document to elastic search
    protected <E, D> void syncEntityToElasticSearch(
            JpaRepository<E, String> jpaRepository,
            ElasticsearchRepository<D, String> esRepository,
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
                esRepository.saveAll(documents);
                page++;
            } while (!entities.isLast());
            logger.info("✔ Synced {} {}s to Elasticsearch", entities.getTotalElements(), entityName);
        }catch (Exception e) {
            logger.error("Failed to sync {} to ElasticSearch: {}", entityName, e.getMessage(), e);
        }
    }

    // Map entity from JPS To document ElasticSearch
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

}
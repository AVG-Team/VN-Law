package avg.vnlaw.lawservice.services;

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
import org.springframework.stereotype.Service;

import java.util.List;
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

    public void syncAllDocumentsToElasticSearch() {
        syncArticleToElasticSearch();
        syncTopicToElasticSearch();
        syncSubjectToElasticSearch();
        syncChapterToElasticSearch();
        syncArticleToElasticSearch();
    }

    // Sync document to elastic search
    private void syncTopicToElasticSearch() {
        List<Topic> topics = topicRepository.findAll();
        List<TopicDocument> esDocument = topics.stream()
                .map(this::topicToElasticSearchDoc)
                .collect(Collectors.toList());

        topicDocumentRepository.saveAll(esDocument);
    }

    private void syncSubjectToElasticSearch() {
        List<Subject> subjects = subjectRepository.findAll();
        List<SubjectDocument> esDocument = subjects.stream()
                .map(this::subjectToElasticSearchDoc)
                .collect(Collectors.toList());
        subjectDocumentRepository.saveAll(esDocument);
    }

    private void syncChapterToElasticSearch() {
        List<Chapter> chapters = chapterRepository.findAll();
        List<ChapterDocument> esDocument = chapters.stream()
                .map(this::chapterToElasticSearchDoc)
                .collect(Collectors.toList());
        chapterDocumentRepository.saveAll(esDocument);
    }

    private void syncArticleToElasticSearch() {
        List<Article> articles = articleRepository.findAll();
        List<ArticleDocument> esDocument = articles.stream()
                .map(this::articleToElasticSearchDoc)
                .collect(Collectors.toList());
        articleDocumentRepository.saveAll(esDocument);
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
package avg.vnlaw.lawservice.services;

import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.dto.response.*;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.ArticleMapper;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.FileRepository;
import avg.vnlaw.lawservice.repositories.TableRepository;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ArticleService implements BaseService<ArticleRequest, String, ArticleResponse> {

    private final ArticleRepository articleRepository ;
    private final FileRepository fileRepository;
    private final TableRepository tableRepository;
    private final TopicRepository topicRepository;
    private ArticleMapper articleMapper;
    private final Logger log = LoggerFactory.getLogger(ArticleService.class);

//    @Cacheable(value = "article", key = "T(java.util.Objects).hash(#chapterId, #pageNo.orElse(0), #pageSize.orElse(10))")
    public Page<ArticleResponse> getArticleByChapter(String chapterId,
                                                     Optional<Integer> pageNo,
                                                     Optional<Integer> pageSize) {
        log.info("Get article by chapter id {}", chapterId);
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        Page<ArticleIntResponse> list = articleRepository.findAllByChapter_IdOrderByOrder(chapterId,pageable);
        List<ArticleResponse> contents =  new ArrayList<>();
        for(ArticleIntResponse item : list.getContent()) {
            String articleId = item.getId();
            List<FileResponse> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<TableResponse> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ArticleResponse articleResponse = ArticleResponse.builder()
                    .id(item.getId())
                    .name(item.getName())
                    .content(item.getContent())
                    .index(item.getIndex())
                    .vbqppl(item.getVbqppl())
                    .vbqpplLink(item.getVbqpplLink())
                    .order(item.getOrder())
                    .files(files)
                    .tables(tables).build();
            contents.add(articleResponse);
        }
        return new PageImpl<>(contents,list.getPageable(),list.getTotalElements());
    }

    @Cacheable(value = "article", key = "T(java.util.Objects).hash(#subjectId.orElse(''), #name.orElse(''), #pageNo.orElse(0), #pageSize.orElse(10))")
    public Page<ArticleResponse> getArticleByFilter(Optional<String> subjectId,
                                                    Optional<String> name,
                                                    Optional<Integer> pageNo,
                                                    Optional<Integer> pageSize) {
        log.info("Get article by subject id and name {} - {} ", subjectId, name);
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(10));

        if(subjectId.isPresent()){
            return articleRepository.findAllFilterWithSubject(subjectId.get(), name.orElse(""), pageable);
        }
        return articleRepository.findAllFilter(name.orElse(""), pageable);
    }


    @Cacheable(value = "article", key = "#articleId")
    public ListTreeResponse getTreeViewByArticleId(String articleId) {
        log.info("Get tree view by article id {}", articleId);
        Article article = articleRepository.findById(articleId).orElseThrow(
                () -> new AppException(ErrorCode.ARTICLE_EMPTY)
        );
        Chapter chapter = article.getChapter();
        List<ArticleIntResponse> articleDTOS = articleRepository.findAllByChapter_IdOrderByOrder(chapter.getId());
        List<ArticleTreeResponse> treeViews = new ArrayList<>();
        for(ArticleIntResponse item  : articleDTOS){
            articleId = item.getId();
            List<FileResponse> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<TableResponse> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ArticleTreeResponse treeViewDTO = ArticleTreeResponse.builder()
                    .id(articleId)
                    .name(item.getName())
                    .content(item.getContent())
                    .index(item.getIndex())
                    .order(item.getOrder())
                    .vbqppl(item.getVbqppl())
                    .vbqpplLink(item.getVbqpplLink())
                    .files(files)
                    .tables(tables)
                    .build();
            treeViews.add(treeViewDTO);
        }

        Topic topic = topicRepository.findById(article.getTopic().getId()).orElseThrow(
                () -> new AppException(ErrorCode.TOPIC_IS_NOT_EXISTED)
        );
        return ListTreeResponse.builder()
                .id(chapter.getId())
                .chapter(
                        Chapter.builder()
                                .id(chapter.getId())
                                .index(chapter.getIndex())
                                .name(chapter.getName())
                                .order(chapter.getOrder())
                                .build()
                )
                .subject(
                        Subject.builder()
                                .id(article.getSubject().getId())
                                .name(article.getSubject().getName())
                                .order(article.getSubject().getOrder())
                                .build()
                )
                .topic(
                        Topic.builder()
                                .id(topic.getId())
                                .name(topic.getName())
                                .order(topic.getOrder())
                                .build()
                )
                .articles(treeViews)
                .build();
    }

    @Override
    public Optional<ArticleResponse> findById(String id) {
        log.info("Get article by id {}", id);
        if (id == null || id.isEmpty()) {
            throw new AppException(ErrorCode.ID_EMPTY);
        }

        Article articleFromDB = articleRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.ARTICLE_EMPTY));

        return Optional.of(articleMapper.toResponse(articleFromDB));
    }


    @Override
    public ArticleResponse create(ArticleRequest entity) {
        log.info("Create article {}", entity);
        if(entity == null || entity.getId() == null){
            throw new AppException(ErrorCode.ARTICLE_EMPTY);
        }

        articleRepository.save(articleMapper.toEntity(entity));
        return articleMapper.requestToResponse(entity);

    }

    @Override
    public ArticleResponse update(ArticleRequest entity) {
        log.info("Update article {}", entity);
        if(entity == null ) throw new AppException(ErrorCode.ARTICLE_EMPTY);
        if(articleRepository.findById(entity.getId()).isEmpty())
            throw new AppException(ErrorCode.ARTICLE_IS_NOT_EXISTED);
        articleRepository.save(articleMapper.toEntity(entity));
        return articleMapper.requestToResponse(entity);
    }

    @Override
    public void delete(String id) {
        if(id == null) throw new AppException(ErrorCode.ARTICLE_IS_NOT_EXISTED);
        articleRepository.deleteById(id);
    }
}

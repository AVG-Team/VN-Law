package avg.vnlaw.lawservice.services;

import avg.vnlaw.lawservice.dto.request.ArticleRequest;
import avg.vnlaw.lawservice.dto.response.*;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.FileRepository;
import avg.vnlaw.lawservice.repositories.TableRepository;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import lombok.RequiredArgsConstructor;
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
public class ArticleService implements BaseService<ArticleRequest, String> {

    private final ArticleRepository articleRepository ;
    private final FileRepository fileRepository;
    private final TableRepository tableRepository;
    private final TopicRepository topicRepository;


    public Page<ArticleResponse> getArticleByChapter(String chapterId,
                                                     Optional<Integer> pageNo,
                                                     Optional<Integer> pageSize) {

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


    public Page<ArticleResponse> getArticleByFilter(Optional<String> subjectId,
                                                    Optional<String> name,
                                                    Optional<Integer> pageNo,
                                                    Optional<Integer> pageSize) {

        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        if(subjectId.isPresent()){
            return articleRepository.findAllFilterWithSubject(subjectId.get(),name.orElse(""),pageable);
        }
        return articleRepository.findAllFilter(name.orElse(""),pageable);
    }


    public ListTreeResponse getTreeViewByArticleId(String articleId) {
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
    public Optional<ArticleRequest> findById(String id) {
        return Optional.empty();
    }

    @Override
    public ArticleRequest create(ArticleRequest entity) {
        return null;
    }

    @Override
    public ArticleRequest update(String id, ArticleRequest entity) {
        return null;
    }

    @Override
    public void delete(String id) {

    }
}

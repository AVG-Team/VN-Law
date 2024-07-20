package avg.vnlaw.lawservice.services.implement;

import avg.vnlaw.lawservice.responses.*;
import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.FileRepository;
import avg.vnlaw.lawservice.repositories.TableRepository;
import avg.vnlaw.lawservice.repositories.TopicRepository;
import avg.vnlaw.lawservice.services.ArticleService;
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
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository ;
    private final FileRepository fileRepository;
    private final TableRepository tableRepository;
    private final TopicRepository topicRepository;

    @Override
    public Page<ResponseArticle> getArticleByChapter(String chapterId,
                                                     Optional<Integer> pageNo,
                                                     Optional<Integer> pageSize) {

        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        Page<ResponseArticleInt> list = articleRepository.findAllByChapter_IdOrderByOrder(chapterId,pageable);
        List<ResponseArticle> contents =  new ArrayList<>();
        for(ResponseArticleInt item : list.getContent()) {
            String articleId = item.getId();
            List<ResponseFile> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<ResponseTable> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ResponseArticle responseArticle = ResponseArticle.builder()
                    .id(item.getId())
                    .name(item.getName())
                    .content(item.getContent())
                    .index(item.getIndex())
                    .vbqppl(item.getVbqppl())
                    .vbqpplLink(item.getVbqpplLink())
                    .order(item.getOrder())
                    .files(files)
                    .tables(tables).build();
            contents.add(responseArticle);
        }
        return new PageImpl<>(contents,list.getPageable(),list.getTotalElements());
    }

    @Override
    public Page<ResponseArticle> getArticleByFilter(Optional<String> subjectId,
                                                    Optional<String> name,
                                                    Optional<Integer> pageNo,
                                                    Optional<Integer> pageSize) {

        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        if(subjectId.isPresent()){
            return articleRepository.findAllFilterWithSubject(subjectId.get(),name.orElse(""),pageable);
        }
        return articleRepository.findAllFilter(name.orElse(""),pageable);
    }

    @Override
    public ResponseListTree getTreeViewByArticleId(String articleId) {
        Article article = articleRepository.findById(articleId).orElseThrow(
                () -> new NotFoundException("Not Exist")
        );
        Chapter chapter = article.getChapter();
        List<ResponseArticleInt> articleDTOS = articleRepository.findAllByChapter_IdOrderByOrder(chapter.getId());
        List<ResponseArticleTree> treeViews = new ArrayList<>();
        for(ResponseArticleInt item  : articleDTOS){
            articleId = item.getId();
            List<ResponseFile> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<ResponseTable> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ResponseArticleTree treeViewDTO = ResponseArticleTree.builder()
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
                () -> new NotFoundException("Topic Not Exist")
        );
        return ResponseListTree.builder()
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
}

package fit.hutech.service.lawservice.services.implement;

import fit.hutech.service.lawservice.DTO.*;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.models.Article;
import fit.hutech.service.lawservice.models.Chapter;
import fit.hutech.service.lawservice.models.Subject;
import fit.hutech.service.lawservice.models.Topic;
import fit.hutech.service.lawservice.repositories.ArticleRepository;
import fit.hutech.service.lawservice.repositories.FileRepository;
import fit.hutech.service.lawservice.repositories.TableRepository;
import fit.hutech.service.lawservice.repositories.TopicRepository;
import fit.hutech.service.lawservice.services.ArticleService;
import jakarta.persistence.Table;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleRepository articleRepository ;
    private final FileRepository fileRepository;
    private final TableRepository tableRepository;
    private final TopicRepository topicRepository;

    @Override
    public Page<ArticleDTO> getArticleByChapter(String chapterId, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        Page<ArticleDTOINT> list = articleRepository.findAllByChapter_IdOrderByOrder(chapterId,pageable);
        List<ArticleDTO> contents =  new ArrayList<>();
        for(ArticleDTOINT item : list.getContent()) {
            String articleId = item.getId();
            List<FileDTO> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<TableDTO> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ArticleDTO articleDTO = new ArticleDTO(
                    item.getId(),
                    item.getName(),
                    item.getContent(),
                    item.getIndex(),
                    item.getVbqppl(),
                    item.getVbqpplLink(),
                    item.getOrder(),
                    files,
                    tables
            );
            contents.add(articleDTO);
        }
        return new PageImpl<>(contents,list.getPageable(),list.getTotalElements());
    }

    @Override
    public Page<ArticleDTO> getArticleByFilter(Optional<String> subjectId, Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(10));
        if(subjectId.isPresent()){
            return articleRepository.findAllFilterWithSubject(subjectId.get(),name.orElse(""),pageable);
        }
        return articleRepository.findAllFilter(name.orElse(""),pageable);
    }

    @Override
    public ListTreeViewDTO getTreeViewByArticleId(String articleId) {
        Article article = articleRepository.findById(articleId).orElseThrow(
                () -> new NotFoundException("Not Exist")
        );
        Chapter chapter = article.getChapter();
        List<ArticleDTOINT> articleDTOS = articleRepository.findAllByChapter_IdOrderByOrder(chapter.getId());
        List<ArticleTreeViewDTO> treeViews = new ArrayList<>();
        for(ArticleDTOINT item  : articleDTOS){
            articleId = item.getId();
            List<FileDTO> files = fileRepository.findAllByArticle_IdOrderByArticle(articleId);
            List<TableDTO> tables = tableRepository.findAllByArticle_IdOrderByArticle(articleId);

            ArticleTreeViewDTO treeViewDTO = ArticleTreeViewDTO.builder()
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
        return ListTreeViewDTO.builder()
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

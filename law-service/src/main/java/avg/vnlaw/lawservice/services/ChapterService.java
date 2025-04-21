package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.request.ChapterRequest;
import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.enums.ErrorCode;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.mapper.ChapterMapper;
import avg.vnlaw.lawservice.repositories.ChapterRepository;
import lombok.RequiredArgsConstructor;
import org.hibernate.annotations.Cache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import javax.swing.text.html.Option;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChapterService implements BaseService<ChapterRequest, String, ChapterResponse> {


    private final ChapterRepository chapterRepository;
    private ChapterMapper chapterMapper;
    private final Logger log = LoggerFactory.getLogger(ChapterService.class);

    @Cacheable(value ="chapter",key = "#chapterId")
    public ChapterResponse getChapter(String chapterId) {
        log.info("ChapterService getChapter chapterId: {}", chapterId);
        chapterRepository.findById(chapterId).orElseThrow(
                () -> new AppException(ErrorCode.CHAPTER_NOT_FOUND)
        );
        return chapterRepository.findChapterById(chapterId);
    }


    @Cacheable(value = "chapters")
    public List<ChapterResponse> getAllChapters() {
        log.info("ChapterService getAllChapters");

        if (chapterRepository.findAll().isEmpty()) {
            throw new AppException(ErrorCode.CHAPTER_EMPTY);
        }

        return chapterRepository.findAllChapters();
    }

    @Cacheable(value ="chapter",key = "#subjectId")
    public List<ChapterResponse> getChaptersBySubject(String subjectId) {
        log.info("ChapterService getChaptersBySubject subjectId: {}", subjectId);
        if (chapterRepository.findChaptersBySubject(subjectId).isEmpty()) {
            throw new AppException(ErrorCode.CHAPTER_EMPTY);
        }
        return chapterRepository.findChaptersBySubject(subjectId);
    }

    @Cacheable(value = "chapter", key = "T(java.util.Objects).hash(#name.orElse(''), #pageNo.orElse(0), #pageSize.orElse(10))")
    public Page<ChapterResponse> getAllChapters(Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        log.info("Get chapters by filter name: {}", name);
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(5));
        if (chapterRepository.findAll(name.orElse(""), pageable).isEmpty()) {
            throw new AppException(ErrorCode.CHAPTER_EMPTY);
        }
        return chapterRepository.findAll(name.orElse(""), pageable);
    }

    @Override
    public Optional<ChapterResponse> findById(String id) {
        log.info("ChapterService findById chapterId: {}", id);
        if(id == null || id.isEmpty())  throw new AppException(ErrorCode.ID_EMPTY);

        Chapter chapter = chapterRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.CHAPTER_NOT_FOUND));

        return Optional.of(chapterMapper.toResponse(chapter));
    }

    @Override
    public ChapterResponse create(ChapterRequest entity) {
        log.info("Creating chapter: {}", entity);
        if(entity == null) throw new AppException(ErrorCode.CHAPTER_EMPTY);
        chapterRepository.save(chapterMapper.toEntity(entity));
        return chapterMapper.requestToResponse(entity);
    }

    @Override
    public ChapterResponse update( ChapterRequest entity) {
        log.info("Updating chapter: {}", entity);
        if(entity == null) throw new AppException(ErrorCode.CHAPTER_EMPTY);
        if(entity.getId() == null || entity.getId().isEmpty()) throw new AppException(ErrorCode.ID_EMPTY);
        chapterRepository.save(chapterMapper.toEntity(entity));
        return chapterMapper.requestToResponse(entity);
    }

    @Override
    public void delete(String id) {
        log.info("Deleting chapter: {}", id);
        chapterRepository.deleteById(id);
    }
}

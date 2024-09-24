package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.dto.response.ChapterResponse;
import avg.vnlaw.lawservice.repositories.ChapterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChapterService implements BaseService<ChapterResponse, String> {


    final ChapterRepository chapterRepository;


    public ChapterResponse getChapter(String chapterId) {
        chapterRepository.findById(chapterId).orElseThrow(
                () -> new NotFoundException("Chapter doesn't exist")
        );
        return chapterRepository.findChapterById(chapterId);
    }


    public List<ChapterResponse> getAllChapters() {
        if (chapterRepository.findAll().isEmpty()) {
            throw new NotFoundException("Chapters are empty");
        }
        return chapterRepository.findAllChapters();
    }


    public List<ChapterResponse> getChaptersBySubject(String subjectId) {
        if (chapterRepository.findChaptersBySubject(subjectId).isEmpty()) {
            throw new NotFoundException("Don't have any chapter of subject");
        }
        return chapterRepository.findChaptersBySubject(subjectId);
    }


    public Page<ChapterResponse> getAllChapters(Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0), pageSize.orElse(5));
        if (chapterRepository.findAll(name.orElse(""), pageable).isEmpty()) {
            throw new NotFoundException("Don't have any chapter");
        }
        return chapterRepository.findAll(name.orElse(""), pageable);
    }

    @Override
    public Optional<ChapterResponse> findById(String id) {
        return Optional.empty();
    }

    @Override
    public ChapterResponse create(ChapterResponse entity) {
        return null;
    }

    @Override
    public ChapterResponse update(String id, ChapterResponse entity) {
        return null;
    }

    @Override
    public void delete(String id) {

    }
}

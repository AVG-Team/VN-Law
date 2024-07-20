package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.responses.ResponseChapter;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.ChapterRepository;
import avg.vnlaw.lawservice.services.ChapterService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChapterServiceImpl implements ChapterService {

    final ChapterRepository chapterRepository;


    @Override
    public ResponseChapter getChapter(String chapterId) {
        chapterRepository.findById(chapterId).orElseThrow(
                () -> new NotFoundException("Chapter doesn't exist")
        );
        return chapterRepository.findChapterById(chapterId);
    }

    @Override
    public List<ResponseChapter> getAllChapters() {
        if(chapterRepository.findAll().isEmpty()){
            throw new NotFoundException("Chapters are empty");
        }
        return chapterRepository.findAllChapters();
    }

    @Override
    public List<ResponseChapter> getChaptersBySubject(String subjectId) {
        if(chapterRepository.findChaptersBySubject(subjectId).isEmpty()){
            throw  new NotFoundException("Don't have any chapter of subject");
        }
        return chapterRepository.findChaptersBySubject(subjectId);
    }

    @Override
    public Page<ResponseChapter> getAllChapters(Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(5) );
        if(chapterRepository.findAll(name.orElse(""),pageable).isEmpty()){
            throw new NotFoundException("Don't have any chapter");
        }
        return chapterRepository.findAll(name.orElse(""),pageable);
    }
}

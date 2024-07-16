package avg.vnlaw.lawservice.services.implement;


import avg.vnlaw.lawservice.DTO.ChapterDTO;
import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.repositories.ChapterRepository;
import avg.vnlaw.lawservice.services.ChapterService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ChapterServiceImpl implements ChapterService {

    final ChapterRepository chapterRepository;

    public ChapterServiceImpl(ChapterRepository chapterRepository){
        this.chapterRepository = chapterRepository;
    }

    @Override
    public Chapter getChapter(String chapterId) {
        chapterRepository.findById(chapterId).orElseThrow(
                () -> new NotFoundException("Chapter doesn't exist")
        );
        return chapterRepository.findById(chapterId).get();
    }

    @Override
    public List<Chapter> getAllChapters() {
        if(chapterRepository.findAll().isEmpty()){
            throw new NotFoundException("Chapters are empty");
        }
        return chapterRepository.findAll();
    }

    @Override
    public List<ChapterDTO> getChaptersBySubject(String subjectId) {
        if(chapterRepository.findChaptersBySubject(subjectId).isEmpty()){
            throw  new NotFoundException("Don't have any chapter of subject");
        }
        return chapterRepository.findChaptersBySubject(subjectId);
    }

    @Override
    public Page<ChapterDTO> getAllChapters(Optional<String> name, Optional<Integer> pageNo, Optional<Integer> pageSize) {
        Pageable pageable = PageRequest.of(pageNo.orElse(0),pageSize.orElse(5) );
        if(chapterRepository.findAll(name.orElse(""),pageable).isEmpty()){
            throw new NotFoundException("Don't have any chapter");
        }
        return chapterRepository.findAll(name.orElse(""),pageable);
    }
}

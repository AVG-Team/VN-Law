package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.DTO.ChapterDTO;
import avg.vnlaw.lawservice.entities.Chapter;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface ChapterService {
    public Chapter getChapter(String chapterId);
    public List<Chapter> getAllChapters();
    public List<ChapterDTO> getChaptersBySubject(String subjectId);
    public Page<ChapterDTO> getAllChapters(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

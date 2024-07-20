package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.responses.ResponseChapter;
import avg.vnlaw.lawservice.entities.Chapter;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface ChapterService {
    public Chapter getChapter(String chapterId);
    public List<Chapter> getAllChapters();
    public List<ResponseChapter> getChaptersBySubject(String subjectId);
    public Page<ResponseChapter> getAllChapters(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

package fit.hutech.service.lawservice.services;

import fit.hutech.service.lawservice.DTO.ChapterDTO;
import fit.hutech.service.lawservice.DTO.SubjectDTO;
import fit.hutech.service.lawservice.models.Chapter;
import fit.hutech.service.lawservice.models.Subject;
import org.springframework.data.domain.Page;

import java.util.List;
import java.util.Optional;

public interface ChapterService {
    public Chapter getChapter(String chapterId);
    public List<Chapter> getAllChapters();
    public List<ChapterDTO> getChaptersBySubject(String subjectId);
    public Page<ChapterDTO> getAllChapters(Optional<String> name , Optional<Integer> pageNo, Optional<Integer> pageSize);
}

package fit.hutech.service.chatservice.models;

import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.DTO.FileDTO;
import lombok.Getter;

import java.util.List;

@Getter
public class AnswerResult {
    // Getters
    private final String answer;
    private final List<ArticleDTO> articles;
    private final String fullAnswer;

    public AnswerResult(String answer, List<ArticleDTO> articles) {
        this.answer = answer;
        this.articles = articles;
        this.fullAnswer = fullAnswer();
    }

    public String reference()
    {
        StringBuilder reference = new StringBuilder();
        for(ArticleDTO article : articles)
        {
            List<FileDTO> files = article.getFiles();
            StringBuilder stringFiles = new StringBuilder();
            for (FileDTO file : files) {
                if(file != null && file.getLink() != null) {
                    stringFiles.append(file.getLink()).append(" ");
                }
            }
            reference.append(article.getVbqppl()).append("\nNguồn: ").append(article.getVbqpplLink());

            if(!stringFiles.isEmpty())
                reference.append("\nTài liệu: ").append(stringFiles).append("\n");
        }
        return reference.toString();
    }

    public String fullAnswer() {
        return answer + "\n" +
                "Tham khảo \n:" + reference();
    }
}

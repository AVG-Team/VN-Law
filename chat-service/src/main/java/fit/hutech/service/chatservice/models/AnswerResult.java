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
    private final List<Vbqppl> vbqppls;
    private final List<Question> questions;
    private final String fullAnswer;
    private final TypeAnswerResult type;

    public AnswerResult(String answer, List<?> list, TypeAnswerResult resultType) {
        this.answer = answer;
        this.articles = resultType == TypeAnswerResult.ARTICLE ? (List<ArticleDTO>) list : null;
        this.vbqppls = resultType == TypeAnswerResult.VBQPPL ? (List<Vbqppl>) list : null;
        this.questions = resultType == TypeAnswerResult.QUESTION ? (List<Question>) list : null;
        this.fullAnswer = fullAnswer();
        this.type = resultType;
    }

    public String reference()
    {
        StringBuilder reference = new StringBuilder();
        if (articles != null) {
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
        } else if (vbqppls != null) {
            for(Vbqppl vbqppl : vbqppls)
            {
                if(!vbqppl.getType().isEmpty())
                    reference.append("\nTheo").append(vbqppl.getType());
                if(!vbqppl.getNumber().isEmpty()) {
                    reference.append("Số Hiệu").append(vbqppl.getType()).append("\n");
                }
            }
        }

        return reference.toString();
    }

    public String fullAnswer() {
        if(questions != null)
            return answer;
        return answer + "\n" +
                "Tham khảo \n:" + reference();
    }
}

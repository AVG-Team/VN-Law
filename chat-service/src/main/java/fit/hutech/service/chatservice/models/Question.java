package fit.hutech.service.chatservice.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Question {
    private String question;
    private String answer;

    public Question(String answer) {
        this.answer = answer;
    }
}

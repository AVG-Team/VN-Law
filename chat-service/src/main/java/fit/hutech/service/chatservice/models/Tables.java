package fit.hutech.service.chatservice.models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "pdtable")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Tables {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String html;

    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_article",nullable = false)
    private Article article;
}

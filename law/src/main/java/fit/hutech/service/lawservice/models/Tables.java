package fit.hutech.service.lawservice.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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

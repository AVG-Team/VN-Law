package fit.hutech.service.lawservice.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "pdfile")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Files {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String link;

    @Column(nullable = false)
    private String path;

    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_article",nullable = false)
    private Article article;
}

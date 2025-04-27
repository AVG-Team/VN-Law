package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "pdfile")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Files extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String link;

    @Column(nullable = false)
    private String path;

    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "article_id",nullable = false)
    private Article article;
}

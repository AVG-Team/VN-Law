package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "pdtable")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Tables extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String html;

    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "article_id",nullable = false)
    private Article article;
}

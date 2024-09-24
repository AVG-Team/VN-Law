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

    @Column(nullable = false)
    private String html;

    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_article",nullable = false)
    private Article article;
}

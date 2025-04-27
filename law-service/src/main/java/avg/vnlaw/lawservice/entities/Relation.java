package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@Entity(name = "pdrelation")
@AllArgsConstructor
@NoArgsConstructor
public class Relation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "artilce_id1")
    private String artilceId1;

    @Column(name = "article_id2")
    private String articleId2;
}

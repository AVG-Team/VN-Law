package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="pdtopic")
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Setter
@Getter
public class Topic extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String name;

    @Column(name = "`order`", nullable = false)
    private Integer order;
}

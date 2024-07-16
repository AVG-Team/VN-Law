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
public class Topic {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private Integer order;


}

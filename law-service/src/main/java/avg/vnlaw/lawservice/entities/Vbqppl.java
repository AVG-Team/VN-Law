package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name="vbqppl")
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
public class Vbqppl {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String content;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String number;

    @Column(nullable = false)
    private String html;

}

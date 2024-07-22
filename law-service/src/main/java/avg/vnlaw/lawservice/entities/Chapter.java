package avg.vnlaw.lawservice.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table( name ="pdchapter")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Chapter {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(name = "`index`", nullable = false)
    private String index;

    @Column(name = "`order`", nullable = false)
    private Integer order;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_subject", nullable = false)
    private Subject subject;
}

package fit.hutech.service.lawservice.models;

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

    @Column(nullable = false)
    private String index;

    @Column(nullable = false)
    private Integer order;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_subject", nullable = false)
    private Subject subject;
}

package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "indexvbqppl")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IndexVbqppl extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "content", columnDefinition = "LONGTEXT",nullable = false)
    private String content;

    @Column(name = "type", nullable = false)
    private String type;

    @Column(nullable = false)
    private String name;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "index_parent")
    private IndexVbqppl indexVbqppl;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_vbqppl")
    private Vbqppl vbqppl;

}

package avg.vnlaw.lawservice.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name ="pdarticle")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@Builder
public class Article extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String content;

    @Column(name = "`index`", nullable = false)
    private String index;

    @Column(nullable = false)
    private String vbqppl;

    @Column(nullable = false)
    private String vbqpplLink;

    @Column(name = "`order`", nullable = false)
    private Integer order;

    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_topic", nullable = false)
    private Topic topic;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_subject",nullable = false)
    private Subject subject;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "id_chapter",nullable = false)
    private Chapter chapter;

}

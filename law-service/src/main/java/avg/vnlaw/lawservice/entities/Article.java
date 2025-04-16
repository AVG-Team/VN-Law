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

    @Column(nullable = false, columnDefinition = "TEXT")
    private String name;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "`index`", nullable = false)
    private String index;

    @Column(nullable = false,columnDefinition = "TEXT")
    private String vbqppl;

    @Column(name = "`order`", nullable = false)
    private Integer order;

    @JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_id",nullable = false)
    private Subject subject;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch =  FetchType.LAZY)
    @JoinColumn(name = "chapter_id",nullable = false)
    private Chapter chapter;

}

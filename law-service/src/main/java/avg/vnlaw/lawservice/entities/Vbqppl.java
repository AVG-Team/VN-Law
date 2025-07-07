package avg.vnlaw.lawservice.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;


@Entity
@Table(name="vbqppl")
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
public class Vbqppl extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer vbqppl_id;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    @Column(nullable = false)
    private String type;

    @Column(nullable = false)
    private String number;

    @Column(nullable = false, columnDefinition = "LONGTEXT")
    private String html;

    @Column(nullable = false,name = "effective_date")
    private Date effectiveDate;

    @Column(name="effective_end_date",nullable = true)
    private Date effectiveEndDate;

    @Column(name="status_code",nullable = false)
    private Integer statusCode;

    @Column(name="issue_date")
    private Date issueDate;

    @Column(name="issuer")
    private String issuer;

    @Column(name="title")
    private String title;
}

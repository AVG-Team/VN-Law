package avg.vnlaw.authservice.entities;

import avg.vnlaw.authservice.enums.TokenTypeForgotPasswordEnum;
import jakarta.persistence.*;
import lombok.*;

import java.sql.Timestamp;

@Getter
@Setter
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "password_reset_token")
public class PasswordResetToken {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false, length = 2048)
    private String token;

    @Column(nullable = false)
    private Timestamp expiryDate;

    @Column(name = "is_activated",nullable = false)
    private boolean isActivated = false;

    @Column(nullable = false)
    private int type = TokenTypeForgotPasswordEnum.EMAIL_VERIFICATION.value;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(nullable = false, name = "user_id")
    private User user;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp createdAt;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp updatedAt;

    @Temporal(TemporalType.TIMESTAMP)
    private Timestamp deletedAt;

    // Lifecycle methods
    @PrePersist
    protected void onCreate() {
        createdAt = new Timestamp(System.currentTimeMillis());
        updatedAt = new Timestamp(System.currentTimeMillis());
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = new Timestamp(System.currentTimeMillis());
    }

    @PreRemove
    protected void onDelete() {
        deletedAt = new Timestamp(System.currentTimeMillis());
    }
}

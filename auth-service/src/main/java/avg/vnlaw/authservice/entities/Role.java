package avg.vnlaw.authservice.entities;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    public enum RoleType {
        ADMIN, USER, SUPER_USER
    }

    @Enumerated(EnumType.STRING)
    private RoleType name;

    @OneToMany(mappedBy = "role")
    private List<User> users;
}

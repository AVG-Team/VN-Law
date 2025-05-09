package avg.vnlaw.authservice.repositories;

import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.entities.RoleType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByName(RoleType name);
    Optional<Role> findById(int id);
    Role findFirstByOrderByIdAsc();
}

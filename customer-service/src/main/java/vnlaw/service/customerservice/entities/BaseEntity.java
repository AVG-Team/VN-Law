package vnlaw.service.customerservice.entities;

import jakarta.persistence.PrePersist;
import jakarta.persistence.PreRemove;
import jakarta.persistence.PreUpdate;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;

/**
 * BaseEntity serves as a base class for all entities in the application.
 * It provides common fields and lifecycle methods for managing timestamps.
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public abstract class BaseEntity {

    /**
     * Timestamp indicating when the entity was created.
     */
    private Timestamp createdTime;

    /**
     * Timestamp indicating the last time the entity was updated.
     */
    private Timestamp updatedTime;

    /**
     * Timestamp indicating when the entity was deleted (soft delete).
     */
    private Timestamp deletedTime;

    /**
     * Lifecycle callback that sets the createdTime field before persisting the entity.
     */
    @PrePersist
    public void onCreated() {
        this.createdTime = new Timestamp(System.currentTimeMillis());
    }

    /**
     * Lifecycle callback that sets the updatedTime field before updating the entity.
     */
    @PreUpdate
    public void onUpdated() {
        this.updatedTime = new Timestamp(System.currentTimeMillis());
    }

    /**
     * Lifecycle callback that sets the deletedTime field before removing the entity.
     * This is used for soft delete functionality.
     */
    @PreRemove
    public void onDeleted() {
        this.deletedTime = new Timestamp(System.currentTimeMillis());
    }
}

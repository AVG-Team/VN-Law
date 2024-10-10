package vnlaw.service.baseservice.service;

import jakarta.persistence.EntityNotFoundException;

import java.util.Optional;

/**
 * BaseService interface for CRUD operations.
 *
 * @param <T> Type of the entity that this service handles. ( DTO -> Request )
 * @param <V> Type of the entity ID. ( type of the primary key like String, Long, etc. )
 */
public interface BaseService<T, V> {

    /**
     * Finds an entity by its ID from the database.
     *
     * @param id the ID of the entity to be retrieved.
     * @return an Optional containing the found entity, or an empty Optional if no entity is found with the given ID.
     */
    Optional<T> findById(V id);

    /**
     * Creates a new entity in the database.
     *
     * @param entity the entity to be created.
     * @return the created entity, which may include generated fields (like ID).
     */
    T create(T entity);

    /**
     * Updates an existing entity in the database.
     *
     * @param id the ID of the entity to be updated.
     * @param entity the entity with updated information.
     * @return the updated entity.
     * @throws EntityNotFoundException if no entity exists with the given ID.
     */
    T update(V id, T entity);

    /**
     * Deletes an entity from the database.
     *
     * @param id the ID of the entity to be deleted.
     * @throws EntityNotFoundException if no entity exists with the given ID.
     */
    void delete(V id);
}

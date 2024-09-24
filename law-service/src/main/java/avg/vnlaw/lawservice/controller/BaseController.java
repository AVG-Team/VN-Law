package avg.vnlaw.lawservice.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * BaseController provides a generic interface for CRUD operations on entities.
 *
 * @param <T> Type of the response entity.
 * @param <U> Type of the request data transfer object. ( DT0 -> Request )
 * @param <I> Type of the entity identifier. ( type of the primary key like String, Long, etc. )
 */
@RestController
@RequestMapping("/api/v1")
public abstract class BaseController<T, U, I> {

    /**
     * Creates a new entity.
     *
     * @param request the data for the new entity.
     * @return the created entity.
     */
    @PostMapping("")
    public abstract ResponseEntity<T> create(@RequestBody U request);

    /**
     * Updates an existing entity.
     *
     * @param id the ID of the entity to be updated.
     * @param request the updated data for the entity.
     * @return the updated entity.
     */
    @PutMapping("/{id}")
    public abstract ResponseEntity<T> update(@PathVariable I id, @RequestBody U request);

    /**
     * Deletes an entity.
     *
     * @param request the identifier or data for the entity to be deleted.
     * @return a response indicating the result of the deletion.
     */
    @DeleteMapping("")
    public abstract ResponseEntity<T> delete(@RequestBody U request);

    /**
     * Retrieves an entity by its identifier.
     *
     * @param request the identifier or criteria to find the entity.
     * @return the found entity.
     */
    @GetMapping("")
    public abstract ResponseEntity<T> get(@RequestBody U request);

    /**
     * Retrieves all entities.
     *
     * @return a list of all entities.
     */
    @GetMapping("/all")
    public abstract ResponseEntity<List<T>> getAll();
}

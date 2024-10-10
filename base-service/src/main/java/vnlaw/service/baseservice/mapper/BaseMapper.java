package vnlaw.service.baseservice.mapper;


import org.mapstruct.MappingTarget;

/**
 * BaseMapper provides generic mapping methods for entities and DTOs.
 *
 * @param <E> Type of the entity.
 * @param <D> Type of the Data Transfer Object (DTO).
 */
public interface BaseMapper<E, D> {

    /**
     * Converts entity to DTO.
     *
     * @param entity the entity to convert.
     * @return the converted DTO.
     */
    D toDto(E entity);

    /**
     * Converts DTO to entity.
     *
     * @param dto the DTO to convert.
     * @return the converted entity.
     */
    E toEntity(D dto);

    /**
     * Updates the entity with values from the DTO.
     *
     * @param dto the DTO with new values.
     * @param entity the entity to update.
     */
    void updateEntityFromDto(D dto, @MappingTarget E entity);
}

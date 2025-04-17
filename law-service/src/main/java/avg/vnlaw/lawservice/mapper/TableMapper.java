package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.response.TableResponse;
import avg.vnlaw.lawservice.entities.Tables;
import jakarta.persistence.Table;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface TableMapper extends BaseMapper<Tables, TableRequest> {
    TableResponse toResponse(Tables table);
    TableResponse requestToResponse(TableRequest request);
}

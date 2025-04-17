package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.VbqpplRequest;
import avg.vnlaw.lawservice.dto.response.VbqpplResponse;
import avg.vnlaw.lawservice.entities.Vbqppl;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface VbqpplMapper extends BaseMapper<Vbqppl, VbqpplRequest> {
    VbqpplResponse toResponse(Vbqppl vbqppl);
    VbqpplResponse requestToResponse(VbqpplRequest request);
}

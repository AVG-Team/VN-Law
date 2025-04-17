package avg.vnlaw.lawservice.mapper;

import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.dto.response.IndexVbqpplResponse;
import avg.vnlaw.lawservice.entities.IndexVbqppl;

public interface IndexVbqpplMapper extends BaseMapper<IndexVbqppl, IndexVbqpplRequest> {
    IndexVbqpplResponse toResponse(IndexVbqppl indexVbqppl);
    IndexVbqpplResponse requestToResponse(IndexVbqpplRequest request);
}

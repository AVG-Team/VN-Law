package avg.vnlaw.authservice.mapper;

import avg.vnlaw.authservice.dto.requests.RegisterRequest;
import avg.vnlaw.authservice.entities.User;
import org.mapstruct.Mapper;

@Mapper(componentModel="spring")
public interface UserMapper {
    User toUser(RegisterRequest registerRequest);
}

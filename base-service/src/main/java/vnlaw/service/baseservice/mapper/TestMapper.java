package vnlaw.service.baseservice.mapper;

import avg.web.backend.dto.request.TestRequest;
import avg.web.backend.entities.Users;

public class TestMapper implements BaseMapper<TestRequest, Users> {


    @Override
    public Users toDto(TestRequest entity) {
        return null;
    }

    @Override
    public TestRequest toEntity(Users dto) {
        return null;
    }

    @Override
    public void updateEntityFromDto(Users dto, TestRequest entity) {

    }
}

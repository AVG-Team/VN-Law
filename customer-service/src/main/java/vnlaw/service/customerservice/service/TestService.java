package vnlaw.service.customerservice.service;

import avg.web.backend.dto.request.TestRequest;

import java.util.Optional;

public class TestService implements BaseService<TestRequest, String> {


    @Override
    public Optional<TestRequest> findById(String id) {
        return Optional.empty();
    }

    @Override
    public TestRequest create(TestRequest entity) {
        return null;
    }

    @Override
    public TestRequest update(String id, TestRequest entity) {
        return null;
    }

    @Override
    public void delete(String id) {

    }
}

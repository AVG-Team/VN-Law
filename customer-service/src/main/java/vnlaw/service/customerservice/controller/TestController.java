package vnlaw.service.customerservice.controller;

import avg.web.backend.dto.request.TestRequest;
import avg.web.backend.entities.Users;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/test")
public class TestController extends BaseController<Users, TestRequest,String> {
    @Override
    public ResponseEntity<Users> create(TestRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Users> update(String id, TestRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Users> delete(TestRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Users> get(TestRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<List<Users>> getAll() {
        return null;
    }
}

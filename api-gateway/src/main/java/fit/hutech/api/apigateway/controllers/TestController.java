package fit.hutech.api.apigateway.controllers;

import com.netflix.appinfo.InstanceInfo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {
    @GetMapping("")
    public String hello() {
        return "Hello World!";
    }
}

package vnlaw.service.customerservice.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/law")
public class LawController {

    @GetMapping("")
    public String getLaw() {
        return "This is law";
    }
}

package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.TableRequest;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.services.TableService;
import jakarta.persistence.Table;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/v1/table")
@RequiredArgsConstructor
public class TableController {

    private final TableService tableService;

    @GetMapping("")
    public ResponseEntity<Object> getAllTables(
            @RequestParam(name = "pageNo", value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize) {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK, tableService.getAllTable(pageNo, pageSize));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllTableByFilter(
            @RequestParam(name = "content", value = "content") Optional<String> content,
            @RequestParam(name = "pageNo", value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize) {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK, tableService.getAllTableByFilter(content, pageNo, pageSize));
    }

}

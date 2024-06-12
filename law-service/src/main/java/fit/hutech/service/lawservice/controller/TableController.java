package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.services.TableService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/law-service/table")
@RequiredArgsConstructor
public class TableController {

    private final TableService tableService;

    @GetMapping("/all")
    public ResponseEntity<Object> getAllTable(
            @RequestParam(name = "pageNo", value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,tableService.getAllTable(pageNo,pageSize));
    }
    @GetMapping("/filter")
    public ResponseEntity<Object> getAllTableByFilter(
            @RequestParam(name = "content", value = "content") Optional<String> content,
            @RequestParam(name = "pageNo", value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,tableService.getAllTableByFilter(content,pageNo,pageSize));
    }
}

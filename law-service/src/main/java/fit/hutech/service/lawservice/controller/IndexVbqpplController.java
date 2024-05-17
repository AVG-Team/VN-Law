package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.services.IndexVbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/indexvbqppl")
@RequiredArgsConstructor
public class IndexVbqpplController {

    private final IndexVbqpplService indexVbqpplService;

    @GetMapping("/{indexId}")
    public ResponseEntity<Object> getIndexVbqppl(@PathVariable Integer indexId) throws NotFoundException {
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.indexVbqpplService.getIndexVbqpplbyId(indexId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllIndexVbqppl(
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.indexVbqpplService.getAllIndexVbqppl(pageNo,pageSize));
    }
}

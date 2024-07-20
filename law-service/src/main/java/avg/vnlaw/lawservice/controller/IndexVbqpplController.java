package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.exception.NotFoundException;
import avg.vnlaw.lawservice.responses.ResponseHandler;
import avg.vnlaw.lawservice.services.IndexVbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/v1/index-vbqppl")
public class IndexVbqpplController {

    @Autowired
    private IndexVbqpplService indexVbqpplService;

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

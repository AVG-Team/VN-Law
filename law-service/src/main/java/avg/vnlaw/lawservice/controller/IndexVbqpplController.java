package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.IndexVbqpplRequest;
import avg.vnlaw.lawservice.entities.IndexVbqppl;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.services.IndexVbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/index-vbqppl")
@RequiredArgsConstructor
public class IndexVbqpplController extends BaseController<IndexVbqppl, IndexVbqpplRequest,Integer> {

    private IndexVbqpplService indexVbqpplService;

    @GetMapping("/{indexId}")
    public ResponseEntity<Object> getIndexVbqppl(@PathVariable Integer indexId) throws AppException {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.indexVbqpplService.getIndexVbqpplbyId(indexId));
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllIndexVbqppl(
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize
    ){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.indexVbqpplService.getAllIndexVbqppl(pageNo,pageSize));
    }

    @Override
    public ResponseEntity<IndexVbqppl> create(IndexVbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<IndexVbqppl> update(Integer id, IndexVbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<IndexVbqppl> delete(IndexVbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<IndexVbqppl> get(IndexVbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<List<IndexVbqppl>> getAll() {
        return null;
    }
}
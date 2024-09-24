package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.VbqpplRequest;
import avg.vnlaw.lawservice.entities.Vbqppl;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/vbqppl")
@RequiredArgsConstructor
public class VbqpplController extends BaseController<Vbqppl, VbqpplRequest,Integer> {

    private VbqpplService vbqpplService;

    @GetMapping("")
    public ResponseEntity<Object> getAllVbqppl(
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize
    ){
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getAllVbqppl(pageNo,pageSize));
    }

    @GetMapping("/{vbqpplId}")
    public ResponseEntity<Object> getVbqpplById(@PathVariable Integer vbqpplId) throws No {
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplById(vbqpplId));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllByType(
            @RequestParam(name = "type", value = "type") Optional<String> type,
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize
    ){

        String decodedType = URLDecoder.decode(type.orElse(""), StandardCharsets.UTF_8);
        return HandlerResponse.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplByType(Optional.of(decodedType.toUpperCase()),pageNo,pageSize));
    }


    @Override
    public ResponseEntity<Vbqppl> create(VbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Vbqppl> update(Integer id, VbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Vbqppl> delete(VbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<Vbqppl> get(VbqpplRequest request) {
        return null;
    }

    @Override
    public ResponseEntity<List<Vbqppl>> getAll() {
        return null;
    }
}

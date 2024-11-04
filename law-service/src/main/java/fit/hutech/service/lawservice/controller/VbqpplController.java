package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

@RestController
@RequestMapping("/law-service/vbqppl")
@RequiredArgsConstructor
public class VbqpplController {

    private final VbqpplService vbqpplService;

    @GetMapping("")
    public ResponseEntity<Object> getAllVbqppl(
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getAllVbqppl(pageNo,pageSize));
    }

    @GetMapping("/{vbqpplId}")
    public ResponseEntity<Object> getVbqpplById(@PathVariable Integer vbqpplId) throws NotFoundException {
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplById(vbqpplId));
    }

    @GetMapping("/all")
    public ResponseEntity<Object> getAll(){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getAll());
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllByType(
            @RequestParam(name = "type", value = "type") Optional<String> type,
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize
    ){

        String decodedType = URLDecoder.decode(type.orElse(""),StandardCharsets.UTF_8);
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplByType(decodedType.toUpperCase(),pageNo,pageSize));
    }


}

package fit.hutech.service.lawservice.controller;

import fit.hutech.service.lawservice.config.response.ResponseHandler;
import fit.hutech.service.lawservice.exception.NotFoundException;
import fit.hutech.service.lawservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/filter/{type}")
    public ResponseEntity<Object> getAllByType(
            @PathVariable String type,
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize){
        String encodedType = URLEncoder.encode(type, StandardCharsets.UTF_8);
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplByType(encodedType,pageNo,pageSize));
    }

    @GetMapping("/filter/{name}")
    public ResponseEntity<Object> getAllByName(
            @PathVariable String name,
            @RequestParam(name = "pageNo", value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize
    ){
        return ResponseHandler.responseBuilder("Complete",
                HttpStatus.OK,this.vbqpplService.getVbqpplByName(name,pageNo,pageSize));
    }


}

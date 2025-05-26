package avg.vnlaw.lawservice.controller;


import avg.vnlaw.lawservice.dto.request.VbqpplRequest;
import avg.vnlaw.lawservice.elastic.documents.VbqpplDocument;
import avg.vnlaw.lawservice.elastic.services.VbqpplDocumentService;
import avg.vnlaw.lawservice.entities.Vbqppl;
import avg.vnlaw.lawservice.dto.response.HandlerResponse;
import avg.vnlaw.lawservice.exception.AppException;
import avg.vnlaw.lawservice.services.VbqpplService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("law/api/vbqppl")
@RequiredArgsConstructor
public class VbqpplController  {

    private final VbqpplService vbqpplService;
    private final VbqpplDocumentService vbqpplDocumentService;

    @GetMapping("")
    public ResponseEntity<Object> getAllVbqppl(
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize",value = "pageSize") Optional<Integer> pageSize
    ){
        return HandlerResponse.responseBuilder("Get all Vbqppl successfully",
                HttpStatus.OK,vbqpplService.getAllVbqppl(pageNo,pageSize));
    }

    @GetMapping("/{vbqpplId}")
    public ResponseEntity<Object> getVbqpplById(@PathVariable Integer vbqpplId) throws AppException {
        return HandlerResponse.responseBuilder("Get Vbqppl successfully",
                HttpStatus.OK,vbqpplService.getVbqpplById(vbqpplId));
    }

    @GetMapping("/filter")
    public ResponseEntity<Object> getAllByType(
            @RequestParam(name = "type", value = "type") Optional<String> type,
            @RequestParam(name = "pageNo",value = "pageNo") Optional<Integer> pageNo,
            @RequestParam(name = "pageSize", value = "pageSize") Optional<Integer> pageSize
    ){

        String decodedType = URLDecoder.decode(type.orElse(""), StandardCharsets.UTF_8);
        return HandlerResponse.responseBuilder("Get all by type successfully",
                HttpStatus.OK,vbqpplService.getVbqpplByType(Optional.of(decodedType.toUpperCase()),pageNo,pageSize));
    }

    @GetMapping("/search")
    public ResponseEntity<Object> elasticSearch(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "type", required = false) String type,
            @RequestParam(name = "pageNo", defaultValue = "0") int pageNo,
            @RequestParam(name = "pageSize", defaultValue = "9") int pageSize,
            @RequestParam(name = "sort", required = false) String sort
    ){
        if (sort != null && !sort.matches("desc|asc|title")) {
            throw new IllegalArgumentException("Invalid sort parameter: " + sort);
        }

        String decodedType = type != null ? URLDecoder.decode(type, StandardCharsets.UTF_8).toUpperCase() : null;
        Page<VbqpplDocument> result = vbqpplDocumentService.search(keyword, decodedType, pageNo, pageSize, sort);
        return HandlerResponse.responseBuilder("Search successfully", HttpStatus.OK, result);
    }

}

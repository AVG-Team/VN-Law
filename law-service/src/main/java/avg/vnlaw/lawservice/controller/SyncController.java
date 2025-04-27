package avg.vnlaw.lawservice.controller;

import avg.vnlaw.lawservice.elastic.services.SyncService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/sync")
@RequiredArgsConstructor
public class SyncController {

    private final SyncService syncService;

    @PostMapping("/syncEls")
    public ResponseEntity<String> syncEls() {
        syncService.syncAllDocumentsToElasticSearch();
        return ResponseEntity.ok("Sync process started. Check logs for progress.");

    }

}

package fit.hutech.service.chatservice.util;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ResponseHolder {
    private static final Map<String, CompletableFuture<String>> HOLDERS = new ConcurrentHashMap<>();

    public static void put(String messageId, CompletableFuture<String> future) {
        HOLDERS.put(messageId, future);
    }

    public static CompletableFuture<String> get(String messageId) {
        return HOLDERS.get(messageId);
    }

    public static void remove(String messageId) {
        HOLDERS.remove(messageId);
    }

    @Scheduled(fixedRate = 300000) // 5 phút
    public void cleanup() {
        HOLDERS.entrySet().removeIf(entry ->
                entry.getValue().isDone() || entry.getValue().isCompletedExceptionally());
    }
}

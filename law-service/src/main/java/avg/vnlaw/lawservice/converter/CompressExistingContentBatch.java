package avg.vnlaw.lawservice.converter;

import avg.vnlaw.lawservice.entities.Article;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.utils.GzipUtil;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class CompressExistingContentBatch {

    private final ArticleRepository repository;
    private final Logger logger = LoggerFactory.getLogger(CompressExistingContentBatch.class);

//    @PostConstruct
    public void compressAllExistingArticles() {
        List<Article> articles = repository.findAll();

        for (Article article : articles) {
            try {
                String originalContent = article.getContent();
                // Bỏ qua nếu đã là base64 nén
                if (isAlreadyCompressed(originalContent)) continue;

                String compressed = GzipUtil.compressToBase64(originalContent);
                article.setContent(compressed);
                repository.save(article);
                logger.info("✔ Compressed article ID: {}", article.getId());
            } catch (IOException e) {
                logger.error("⚠ Error compressing article ID: {} - {}", article.getId(), e.getMessage());
            }
        }
    }

    private boolean isAlreadyCompressed(String text) {
        try {
            GzipUtil.decompressFromBase64(text);
            return true; // giải nén thành công => đã nén rồi
        } catch (Exception e) {
            return false; // giải nén thất bại => chưa nén
        }
    }

    public void benchmarkRead() {
        long start = System.currentTimeMillis();

        List<Article> articles = repository.findAll();
        for (Article article : articles) {
            String content = article.getContent(); // auto decompress ở đây
            // Không cần xử lý gì thêm
        }

        long end = System.currentTimeMillis();
        System.out.println("⏱ Time taken to read 1000 records: " + (end - start) + " ms");
    }
}

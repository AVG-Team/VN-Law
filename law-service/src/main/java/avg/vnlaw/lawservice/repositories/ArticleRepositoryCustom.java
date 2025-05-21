package avg.vnlaw.lawservice.repositories;

import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.function.Consumer;

@Repository
public class ArticleRepositoryCustom {
    private final DataSource dataSource;

    public ArticleRepositoryCustom(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void fetchArticlesInBatches(int batchSize, Consumer<Object[]> consumer) {
        String sql = "SELECT a.content, s.name AS subjectName, c.name AS chapterName, t.name AS topicName, a.vbqppl_link " +
                "FROM pdarticle a " +
                "JOIN pdsubject s ON a.subject_id = s.id " +
                "JOIN pdchapter c ON a.chapter_id = c.id " +
                "JOIN pdtopic t ON a.topic_id = t.id " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = dataSource.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt = conn.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY)) {
                stmt.setFetchSize(batchSize);
                long offset = 0;
                boolean hasMoreData = true;

                while (hasMoreData) {
                    stmt.setInt(1, batchSize);
                    stmt.setLong(2, offset);
                    try (ResultSet rs = stmt.executeQuery()) {
                        hasMoreData = false;
                        while (rs.next()) {
                            hasMoreData = true;
                            Object[] result = new Object[] {
                                    rs.getString("content"),
                                    rs.getString("subjectName"),
                                    rs.getString("chapterName"),
                                    rs.getString("topicName"),
                                    rs.getString("vbqppl_link")
                            };
                            consumer.accept(result);
                        }
                    }
                    offset += batchSize;
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error fetching articles: " + e.getMessage(), e);
        }
    }
}
package avg.vnlaw.lawservice.elastic.services;

import avg.vnlaw.lawservice.elastic.documents.TopicDocument;
import avg.vnlaw.lawservice.elastic.documents.VbqpplDocument;
import avg.vnlaw.lawservice.elastic.repositories.TopicDocumentRepository;
import avg.vnlaw.lawservice.elastic.repositories.VbqpplDocumentRepository;
import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.entities.Vbqppl;
import co.elastic.clients.elasticsearch._types.query_dsl.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.elasticsearch.client.elc.NativeQuery;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class VbqpplDocumentService {

    private final VbqpplDocumentRepository repository;
    private final ElasticsearchOperations elasticsearchOperations;

    public void index(Vbqppl entity) {
        VbqpplDocument vbqpplDocument = VbqpplDocument.builder()
                .id(entity.getVbqppl_id())
                .html(entity.getHtml())
                .content(entity.getContent())
                .type(entity.getType())
                .build();

        repository.save(vbqpplDocument);
    }
    public Page<VbqpplDocument> search(String keyword, String type, int pageNo, int pageSize, String sort) {
        log.info("Searching Vbqppl with keyword: {}, type: {}, pageNo: {}, pageSize: {}, sort: {}",
                keyword, type, pageNo, pageSize, sort);

        // Xây dựng truy vấn
        Query query = Query.of(q -> q.bool(b -> {
            // Bước 1: Tìm kiếm với keyword
            if (keyword != null && !keyword.isEmpty()) {
                b.must(Query.of(q2 -> q2.multiMatch(m -> m
                        .query(keyword)
                        .fields("content", "title")  // Tìm trên content và title
                        .fuzziness("0")              // Tắt fuzziness để khớp chính xác
                )));
            } else {
                // Nếu không có keyword, trả về tất cả tài liệu
                b.must(Query.of(q2 -> q2.matchAll(m -> m)));
            }

            // Bước 2: Lọc theo type
            if (type != null && !type.isEmpty() && !type.equalsIgnoreCase("all")) {
                b.must(Query.of(q2 -> q2.match(m -> m
                        .field("type")
                        .query(type)
                        .fuzziness("0")
                )));
            }
            return b;
        }));

        // Bước 3: Xử lý sắp xếp
        Sort sortObj;
        if (sort != null) {
            switch (sort.toLowerCase()) {
                case "desc":
                    sortObj = Sort.by(Sort.Direction.DESC, "issueDate");
                    break;
                case "asc":
                    sortObj = Sort.by(Sort.Direction.ASC, "issueDate");
                    break;
                case "title":
                    sortObj = Sort.by(Sort.Direction.ASC, "title.keyword");  // Sử dụng title.keyword
                    break;
                default:
                    sortObj = Sort.unsorted();
                    break;
            }
        } else {
            sortObj = Sort.unsorted();
        }

        // Tạo truy vấn với phân trang và sắp xếp
        NativeQuery searchQuery = NativeQuery.builder()
                .withQuery(query)
                .withPageable(PageRequest.of(pageNo, pageSize, sortObj))
                .build();

        // Thực hiện truy vấn
        SearchHits<VbqpplDocument> hits = elasticsearchOperations.search(searchQuery, VbqpplDocument.class);

        // Chuyển đổi kết quả
        List<VbqpplDocument> content = hits.getSearchHits().stream()
                .map(SearchHit::getContent)
                .collect(Collectors.toList());
        if (!content.isEmpty()) {
            log.info("Search completed. Content: {}", content.getFirst().getType()); // Log the first item for brevity
        }

        log.info("Found {} results for keyword: {}, type: {}", content.size(), keyword, type);

        return new PageImpl<>(content, PageRequest.of(pageNo, pageSize, sortObj), hits.getTotalHits());
    }
}

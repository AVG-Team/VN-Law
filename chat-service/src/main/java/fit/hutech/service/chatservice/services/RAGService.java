package fit.hutech.service.chatservice.services;

import dev.langchain4j.data.embedding.Embedding;
import dev.langchain4j.data.segment.TextSegment;
import dev.langchain4j.store.embedding.EmbeddingMatch;
import fit.hutech.service.chatservice.DTO.ArticleDTO;
import fit.hutech.service.chatservice.models.AnswerResult;

import java.util.List;

public interface RAGService {
    public List<ArticleDTO> getDataBeyondToken();

    public AnswerResult getAnswer(String question);
}
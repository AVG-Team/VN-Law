package fit.hutech.service.chatservice.services;

import tech.amikos.chromadb.handler.ApiException;

import java.util.List;
import java.util.Set;

public interface ChromaService {
    Set<String> getExistingIds() throws ApiException;

    public List<String> importDataFromArticle() throws ApiException;
}

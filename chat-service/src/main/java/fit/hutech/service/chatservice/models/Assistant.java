package fit.hutech.service.chatservice.models;

import dev.langchain4j.service.UserMessage;

public interface Assistant {
    @UserMessage("Trả lời bằng tiếng việt:")
    String answer(String query);
}
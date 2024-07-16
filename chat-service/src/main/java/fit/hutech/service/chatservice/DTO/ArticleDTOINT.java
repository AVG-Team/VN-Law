package fit.hutech.service.chatservice.DTO;

public interface ArticleDTOINT {
    String getId();
    String getName();
    Integer getOrder();
    String getContent();
    String getIndex();
    String getVbqppl();
    String getVbqpplLink();
    Boolean getIsEmbedded();

    // Add these methods
    String getSubjectName();
    String getTopicName();
    String getChapterName();
}

package fit.hutech.service.lawservice.services;

import java.util.List;
import fit.hutech.service.lawservice.models.Topic;

public interface TopicService {
    public String createTopic(Topic topic);
    public String updateTopic(Topic topic);
    public String deleteTopic(Topic topic);
    public Topic getTopic(String topicId);
    public List<Topic> getAllTopic();
}

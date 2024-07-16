package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.entities.Topic;

import java.util.List;

public interface TopicService {
    public String createTopic(Topic topic);
    public String updateTopic(Topic topic);
    public String deleteTopic(Topic topic);
    public Topic getTopic(String topicId);
    public List<Topic> getAllTopic();
}

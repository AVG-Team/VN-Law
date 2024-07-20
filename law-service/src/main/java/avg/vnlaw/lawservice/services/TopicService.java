package avg.vnlaw.lawservice.services;


import avg.vnlaw.lawservice.entities.Topic;
import avg.vnlaw.lawservice.responses.ResponseTopic;

import java.util.List;

public interface TopicService {
    public ResponseTopic getTopic(String topicId);
    public List<ResponseTopic> getAllTopic();
}

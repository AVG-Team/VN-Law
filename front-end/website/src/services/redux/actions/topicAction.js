export const TopicActionTypes = {
    GET_BY_TOPIC_ID_REQUEST: "GET_BY_TOPIC_ID_REQUEST",
    GET_BY_TOPIC_ID_SUCCESS: "GET_BY_TOPIC_ID_SUCCESS",
    GET_BY_TOPIC_ID_FAILURE: "GET_BY_TOPIC_ID_FAILURE",

    GET_ALL_TOPICS_REQUEST: "GET_ALL_TOPICS_REQUEST",
    GET_ALL_TOPICS_SUCCESS: "GET_ALL_TOPICS_SUCCESS",
    GET_ALL_TOPICS_FAILURE: "GET_ALL_TOPICS_FAILURE",
};

export const getById = (topidId) => ({
    type: TopicActionTypes.GET_BY_TOPIC_ID_REQUEST,
    payload: vbqpplId,
});

export const getAll = () => ({
    type: TopicActionTypes.GET_ALL_TOPICS_REQUEST,
});

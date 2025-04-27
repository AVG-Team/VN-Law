import { useState } from "react";
import NewTopicForm from "./components/NewTopicForm";
import TopicList from "./components/TopicList";
import TopicDetail from "./components/TopicDetai";

export default function Index() {
    const [topics, setTopics] = useState([
        { id: 1, title: "Welcome to the forum!", content: "Feel free to share your ideas!", replies: [] },
        { id: 2, title: "ReactJS vs VueJS", content: "Which one do you prefer?", replies: [] },
    ]);

    const [selectedTopic, setSelectedTopic] = useState(null);

    const addTopic = (newTopic) => {
        setTopics([...topics, { ...newTopic, id: topics.length + 1, replies: [] }]);
    };

    const addReply = (topicId, replyContent) => {
        setTopics(
            topics.map((topic) =>
                topic.id === topicId ? { ...topic, replies: [...topic.replies, replyContent] } : topic,
            ),
        );
    };

    return (
        <div className="min-h-screen p-6 bg-gray-100">
            <h1 className="mb-6 text-3xl font-bold text-center text-blue-600">Diễn đàn pháp luật</h1>
            <div className="max-w-5xl p-6 mx-auto bg-white rounded-lg shadow">
                {!selectedTopic ? (
                    <>
                        <NewTopicForm addTopic={addTopic} />
                        <TopicList topics={topics} setSelectedTopic={setSelectedTopic} />
                    </>
                ) : (
                    <TopicDetail topic={selectedTopic} addReply={addReply} goBack={() => setSelectedTopic(null)} />
                )}
            </div>
        </div>
    );
}

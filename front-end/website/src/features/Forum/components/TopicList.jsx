import React from "react";

const TopicList = ({ topics, setSelectedTopic }) => {
    return (
        <div>
            <h2 className="mb-4 text-lg font-bold">Topics</h2>
            <ul className="divide-y divide-gray-300">
                {topics.map((topic) => (
                    <li
                        key={topic.id}
                        className="p-4 cursor-pointer hover:bg-gray-100"
                        onClick={() => setSelectedTopic(topic)}
                    >
                        <h3 className="font-bold text-blue-600">{topic.title}</h3>
                        <p className="text-sm text-gray-600">{topic.content}</p>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default TopicList;

import React, { useState } from "react";

const TopicDetail = ({ topic, addReply, goBack }) => {
    const [reply, setReply] = useState("");

    const handleReply = (e) => {
        e.preventDefault();
        if (reply.trim()) {
            addReply(topic.id, reply);
            setReply("");
        }
    };

    return (
        <div>
            <button onClick={goBack} className="mb-4 text-blue-500 underline">
                Back to Topics
            </button>
            <h2 className="mb-2 text-2xl font-bold">{topic.title}</h2>
            <p className="mb-4 text-gray-700">{topic.content}</p>
            <div className="mb-6">
                <h3 className="mb-2 font-bold">Replies</h3>
                <ul className="space-y-2">
                    {topic.replies.map((reply, index) => (
                        <li key={index} className="p-2 bg-gray-100 rounded">
                            {reply}
                        </li>
                    ))}
                </ul>
            </div>
            <form onSubmit={handleReply}>
                <textarea
                    className="w-full p-2 mb-4 border border-gray-300 rounded"
                    placeholder="Write your reply..."
                    value={reply}
                    onChange={(e) => setReply(e.target.value)}
                />
                <button type="submit" className="px-4 py-2 text-white bg-green-500 rounded hover:bg-green-600">
                    Post Reply
                </button>
            </form>
        </div>
    );
};

export default TopicDetail;

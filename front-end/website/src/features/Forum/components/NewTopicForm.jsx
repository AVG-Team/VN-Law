import React, { useState } from "react";

const NewTopicForm = ({ addTopic }) => {
    const [title, setTitle] = useState("");
    const [content, setContent] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();
        addTopic({ title, content });
        setTitle("");
        setContent("");
    };

    return (
        <form onSubmit={handleSubmit} className="mb-6">
            <h2 className="mb-4 text-lg font-bold">Add New Topic</h2>
            <div className="mb-4">
                <input
                    type="text"
                    className="w-full p-2 border border-gray-300 rounded"
                    placeholder="Topic Title"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    required
                />
            </div>
            <div className="mb-4">
                <textarea
                    className="w-full p-2 border border-gray-300 rounded"
                    placeholder="Topic Content"
                    value={content}
                    onChange={(e) => setContent(e.target.value)}
                    required
                />
            </div>
            <button type="submit" className="px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600">
                Add Topic
            </button>
        </form>
    );
};

export default NewTopicForm;

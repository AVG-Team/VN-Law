import { useState, useEffect, useRef } from "react";
import TextareaAutosize from "react-textarea-autosize";
import { ChevronLeftIcon, ChevronRightIcon, EllipsisVerticalIcon, PaperAirplaneIcon } from "@heroicons/react/24/solid";
import { TopQuestions } from "./LawQuestions";
import VersionChatbot from "./VersionChatbot";
import MenuMobile from "./MenuMobile";

function Dialog({ isOpenMenuNavbar, setIsOpenMenuNavbar, messages, setMessages, activeChat, setActiveChat }) {
    const [isHoveredIconMenu, setIsHoveredIconMenu] = useState(false);
    const [isHiddenRight, setHiddenRight] = useState(true);
    const [showIconSend, setShowIconSend] = useState(false);
    const [windowWidth, setWindowWidth] = useState(window.innerWidth);
    const [textareaValue, setTextareaValue] = useState("");
    const messagesEndRef = useRef(null);

    const handleResize = () => {
        setWindowWidth(window.innerWidth);
    };

    useEffect(() => {
        window.addEventListener("resize", handleResize);
        return () => {
            window.removeEventListener("resize", handleResize);
        };
    }, []);

    const handleQuestionChange = (e) => {
        const question = e.target.value;
        setTextareaValue(e.target.value);
        setShowIconSend(question.trim().length > 0);
    };

    const handleClick = () => {
        if (windowWidth < 1024 && isOpenMenuNavbar) {
            setIsOpenMenuNavbar(false);
        }
    };

    const Reply =
        "Theo quy định tại Điều 251, Bộ luật Hình sự 2015 thì tội mua bán trái phép chất ma tuý bị xử lý Hình sự như sau: 1. Người nào mua bán trái phép chất ma túy, thì bị phạt tù từ 02 năm đến 07 năm.";

    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            e.preventDefault();
            handleSendQuestion();
        }
    };

    const handleSendQuestion = () => {
        if (textareaValue.trim() !== "") {
            sendQuestion(textareaValue.trim());
        }
    };
    const sendQuestion = (content) => {
        if (content !== "") {
            const newMessage = {
                id: messages.length + 1,
                content: content,
                type: "question",
            };
            setActiveChat(true);
            setMessages((prevMessages) => [...prevMessages, newMessage]);
            fetchFakeReply(newMessage);

            setTextareaValue("");
        }
    };

    const fetchFakeReply = (message) => {
        const fakeReply = {
            id: messages.length + 2,
            content: Reply,
            type: "reply",
        };

        setMessages((prevMessages) => [...prevMessages, fakeReply]);
    };

    useEffect(() => {
        if (activeChat) {
            scrollToBottom();
        }
    }, [messages, activeChat]);

    const scrollToBottom = () => {
        if (messagesEndRef.current) {
            messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
        }
    };

    const clearMessages = () => {
        setActiveChat(false);
        setMessages([]);
    };

    return (
        <div
            className={`flex flex-col relative w-[100%] h-screen z-0 ${activeChat ? "active-chat" : ""}`}
            onClick={handleClick}
        >
            <MenuMobile
                isOpenMenuNavbar={isOpenMenuNavbar}
                setIsOpenMenuNavbar={setIsOpenMenuNavbar}
                clearMessages={clearMessages}
            />
            <hr />
            <div className="hidden lg:block absolute top-[50%]">
                {isHoveredIconMenu ? (
                    isHiddenRight ? (
                        <ChevronLeftIcon
                            onMouseLeave={() => setIsHoveredIconMenu(false)}
                            onClick={() => {
                                setHiddenRight(false);
                                setIsOpenMenuNavbar(false);
                                setIsHoveredIconMenu(false);
                            }}
                            className="w-6 h-6 text-gray-400 hover:text-gray-800 cursor-pointer"
                        />
                    ) : (
                        <ChevronRightIcon
                            onMouseLeave={() => setIsHoveredIconMenu(false)}
                            onClick={() => {
                                setHiddenRight(true);
                                setIsOpenMenuNavbar(true);
                                setIsHoveredIconMenu(false);
                            }}
                            className="w-6 h-6 text-gray-400 hover:text-gray-800 cursor-pointer"
                        />
                    )
                ) : (
                    <EllipsisVerticalIcon
                        className="w-6 h-6 text-gray-400 hover:text-gray-800 cursor-pointer"
                        onMouseLeave={() => setIsHoveredIconMenu(false)}
                        onMouseEnter={() => setIsHoveredIconMenu(true)}
                    />
                )}
            </div>
            <div className="flex-1 overflow-hidden">
                <VersionChatbot
                    className="hidden lg:flex lg:items-center absolute top-4 left-8 rounded-lg cursor-pointer hover:bg-slate-300 px-2"
                    clearMessages={clearMessages}
                    isOpenMenuNavbar={isOpenMenuNavbar}
                />
                <div className="flex items-center justify-center flex-col h-full logo-chat">
                    <img src="https://cdn-icons-png.flaticon.com/512/432/432594.png" alt="icon" className="w-12" />
                    <p className="text-2xl font-bold mt-3">How can I help you today?</p>
                </div>
                <div className="flex flex-col h-full overflow-scroll">
                    {messages.map((message) => (
                        <div
                            key={message.id}
                            className={`message-chat ${
                                message.type === "question" ? "question" : "reply"
                            } w-full flex justify-${message.type === "question" ? "end" : "start"} px-3 mt-5`}
                        >
                            <div
                                className={`flex rounded-lg ${
                                    message.type === "question" ? "bg-primary" : "bg-gray-100"
                                } p-4`}
                            >
                                <p
                                    className={`${
                                        message.type === "question" ? "text-gray-100" : "text-black"
                                    } text-lg`}
                                >
                                    {message.content}
                                </p>
                            </div>
                        </div>
                    ))}
                    <div ref={messagesEndRef} />
                </div>
            </div>
            <div className="w-[100%] text-center mb-2">
                <TopQuestions sendQuestion={sendQuestion} />
                <div className="position">
                    <TextareaAutosize
                        name="question"
                        id="question"
                        className="resize-none w-10/12 border-[0.25px] border-b border-gray-400 text-gray-900 pl-3 py-2 placeholder:text-gray-400 focus:border-gray-600 focus-visible:outline-0 focus:ring-0 sm:text-sm sm:leading-6 rounded-lg"
                        placeholder="Add your Question..."
                        minRows={1}
                        maxRows={5}
                        value={textareaValue}
                        onChange={handleQuestionChange}
                        onKeyDown={handleKeyDown}
                    />
                    {showIconSend && (
                        <PaperAirplaneIcon
                            className="w-6 h-6 text-gray-400 absolute right-[9.5%] bottom-12 cursor-pointer hover:text-gray-900"
                            onClick={handleSendQuestion}
                        />
                    )}
                </div>
                <p className="text-base opacity-50">
                    AVG LAW AI can make mistakes. Consider checking important information.
                </p>
            </div>
        </div>
    );
}

export default Dialog;

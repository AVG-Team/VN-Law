import { useEffect, useRef, useState, useCallback } from "react";
import TextareaAutosize from "react-textarea-autosize";
import SockJS from "sockjs-client";
import Stomp from "stompjs";
import {
    ChevronLeftIcon,
    ChevronRightIcon,
    EllipsisVerticalIcon,
    PaperAirplaneIcon,
    StopCircleIcon,
} from "@heroicons/react/24/solid";
import { v4 as uuidv4 } from "uuid";
import { TopQuestions } from "./LawQuestions";
import VersionChatbot from "./VersionChatbot";
import MenuMobile from "./MenuMobile";
import TypewriterText from "./TypewriterText";
import Logo from "~/assets/images/logo/logo-no-bg.png";
import axiosClient from "../../../api/axiosClient";
import useWebSocketChat from "../../../hook/useSocketChat";

function Dialog({ isOpenMenuNavbar, setIsOpenMenuNavbar, messages, setMessages, activeChat, setActiveChat }) {
    const [isHoveredIconMenu, setIsHoveredIconMenu] = useState(false);
    const [isHiddenRight, setHiddenRight] = useState(true);
    const [showIconSend, setShowIconSend] = useState(false);
    const [windowWidth, setWindowWidth] = useState(window.innerWidth);
    const [textareaValue, setTextareaValue] = useState("");
    const [pendingReplyServer, setPendingReplyServer] = useState(false);
    const messagesEndRef = useRef(null);
    const [isWaiting, setIsWaiting] = useState(false);
    const socketRef = useRef();

    const handleResize = useCallback(() => {
        setWindowWidth(window.innerWidth);
    }, []);
    const baseUrl = axiosClient.defaults.baseURL;
    const { sendMessage, connectionStatus, pendingMessages } = useWebSocketChat(baseUrl);
    console.log(baseUrl);

    useEffect(() => {
        window.addEventListener("resize", handleResize);
        return () => window.removeEventListener("resize", handleResize);
    }, [handleResize]);

    const handleQuestionChange = useCallback((e) => {
        const question = e.target.value;
        setTextareaValue(question);
        setShowIconSend(question.trim().length > 0);
    }, []);

    const handleClick = useCallback(() => {
        if (windowWidth < 1024 && isOpenMenuNavbar) {
            setIsOpenMenuNavbar(false);
        }
    }, [windowWidth, isOpenMenuNavbar]);

    const handleKeyDown = useCallback((e) => {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            handleSendQuestion();
        }
    }, []);

    const handleSendQuestion = useCallback(() => {
        if (!textareaValue.trim()) return;

        const newMessage = {
            userId: uuidv4(),
            content: textareaValue.trim(),
            type: "question",
        };

        setActiveChat(true);
        setIsWaiting(true);
        setMessages((prev) => [...prev, newMessage]);

        const messageId = sendMessage(newMessage.content);
        setTextareaValue("");

        // Track message status
        if (messageId) {
            console.log(`Message ${messageId} sent, awaiting response...`);
        }
    }, [textareaValue, sendMessage]);

    const onMessageReceived = useCallback((message) => {
        const replyMessage = {
            id: uuidv4(),
            content: message,
            type: "reply",
        };

        setMessages((prev) => [...prev, replyMessage]);
        setIsWaiting(false);
    }, []);

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
            <div className="justify-start justify-end hidden"></div>
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
                            className="w-6 h-6 text-gray-400 cursor-pointer hover:text-gray-800"
                        />
                    ) : (
                        <ChevronRightIcon
                            onMouseLeave={() => setIsHoveredIconMenu(false)}
                            onClick={() => {
                                setHiddenRight(true);
                                setIsOpenMenuNavbar(true);
                                setIsHoveredIconMenu(false);
                            }}
                            className="w-6 h-6 text-gray-400 cursor-pointer hover:text-gray-800"
                        />
                    )
                ) : (
                    <EllipsisVerticalIcon
                        className="w-6 h-6 text-gray-400 cursor-pointer hover:text-gray-800"
                        onMouseLeave={() => setIsHoveredIconMenu(false)}
                        onMouseEnter={() => setIsHoveredIconMenu(true)}
                    />
                )}
            </div>
            <div className="flex-1 overflow-hidden">
                <VersionChatbot
                    className="absolute hidden px-2 rounded-lg cursor-pointer lg:flex lg:items-center top-4 left-8 hover:bg-slate-300"
                    clearMessages={clearMessages}
                    isOpenMenuNavbar={isOpenMenuNavbar}
                />
                <div className="flex flex-col items-center justify-center h-full logo-chat">
                    <img src={Logo} alt="icon" className="w-20" />
                    <p className="mt-3 text-2xl font-bold">Tôi có thể giúp gì cho bạn ?</p>
                </div>
                <div className="flex flex-col h-full overflow-scroll lg:py-10">
                    {messages.map((message, index) => (
                        <div
                            key={index}
                            className={`message-chat ${
                                message.type === "question" ? "question" : "reply"
                            } w-full flex justify-${message.type === "question" ? "end" : "start"} px-3 mt-5`}
                        >
                            <div
                                className={`flex rounded-lg ${
                                    message.type === "question" ? "bg-cyan-300" : "bg-gray-100"
                                } p-4`}
                            >
                                {message.type === "question" ? (
                                    <p className="text-lg text-white">{message.content}</p>
                                ) : (
                                    <TypewriterText
                                        key={message.content}
                                        text={message.content}
                                        pendingReplyServer={pendingReplyServer}
                                        setPendingReplyServer={setPendingReplyServer}
                                    />
                                )}
                            </div>
                        </div>
                    ))}
                    {isWaiting && (
                        <div className={`message-chat reply w-full flex justify-start px-3 mt-5`}>
                            <div className={`flex rounded-lg bg-gray-100 p-4`}>
                                <div className="lds-ellipsis">
                                    <div></div>
                                    <div></div>
                                    <div></div>
                                    <div></div>
                                </div>
                            </div>
                        </div>
                    )}
                    <div ref={messagesEndRef} />
                </div>
            </div>
            <div className="w-[100%] text-center mb-2">
                <TopQuestions sendQuestion={handleSendQuestion} />
                <div className="position">
                    <TextareaAutosize
                        name="question"
                        id="question"
                        className="resize-none w-10/12 border-[0.25px] border-b border-gray-400 text-gray-900 pl-3 py-2 placeholder:text-gray-400 focus:border-gray-600 focus-visible:outline-0 focus:ring-0 sm:text-sm sm:leading-6 rounded-lg"
                        placeholder="Đặt câu hỏi cho chúng tôi tại đây..."
                        minRows={1}
                        maxRows={5}
                        readOnly={pendingReplyServer}
                        value={textareaValue}
                        onChange={handleQuestionChange}
                        onKeyDown={handleKeyDown}
                    />
                    {showIconSend && (
                        <>
                            {!pendingReplyServer ? (
                                <PaperAirplaneIcon
                                    className="w-6 h-6 text-gray-400 absolute right-[9.5%] bottom-12 cursor-pointer hover:text-gray-900 icon-input-message"
                                    onClick={handleSendQuestion}
                                />
                            ) : (
                                <StopCircleIcon className="w-6 h-6 text-gray-400 absolute right-[9.5%] bottom-12 cursor-progress icon-input-message" />
                            )}
                        </>
                    )}
                </div>
                <p className="text-base opacity-50">
                    AVG LAW AI có thể có những sai lầm. Hãy xem xét thông tin quan trọng.
                </p>
            </div>
        </div>
    );
}

export default Dialog;

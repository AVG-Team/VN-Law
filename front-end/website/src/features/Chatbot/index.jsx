import { useEffect, useState } from "react";
import Navbar from "./components/Navbar";
import Dialog from "./components/Dialog";
import { useMediaQuery } from "react-responsive";

export default function Chatbot(props) {
    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";
        if (title === "Chat Bot") {
            document.body.style.overflowY = "hidden";
        }
    }, [title]);
    const nameUser = "AVG Nguyễn Tấn Dũng";

    const isLargeScreen = useMediaQuery({ query: "(min-width: 1024px)" });
    const boolOpenMenu = isLargeScreen ? true : false;
    const [isOpenMenuNavbar, setIsOpenMenuNavbar] = useState(boolOpenMenu);
    const [messages, setMessages] = useState([]);
    const [activeChat, setActiveChat] = useState(false);

    const clearMessages = () => {
        setActiveChat(false);
        setMessages([]);
    };

    return (
        <div className="flex flex-row">
            <Navbar isOpenMenuNavbar={isOpenMenuNavbar} nameUser={nameUser} clearMessages={clearMessages} />
            <Dialog
                isOpenMenuNavbar={isOpenMenuNavbar}
                setIsOpenMenuNavbar={setIsOpenMenuNavbar}
                messages={messages}
                setMessages={setMessages}
                activeChat={activeChat}
                setActiveChat={setActiveChat}
            />
        </div>
    );
}

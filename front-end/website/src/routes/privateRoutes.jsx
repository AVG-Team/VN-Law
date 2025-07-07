// Desc: Private routes for the application ( require authentication to access )
import SignOut from "~/features/SignOut";
import Chatbot from "~/features/Chatbot";
import VerifyEmail from "~/features/VerifyEmail";
import Profile from "~/features/Profile";
import AuthLayout from "~/components/layout/AuthLayout";

const privateRoutes = [
    {
        id: 1,
        path: "/sign-out",
        element: <SignOut />,
        private: true,
        title: "Đăng xuất",
    },
    {
        id: 2,
        path: "/chat-bot",
        element: <Chatbot />,
        private: true,
        title: "Chatbot",
    },
    {
        id: 3,
        path: "/verify-email",
        element: <VerifyEmail />,
        private: true,
        title: "Xác thực email",
    },
    {
        id: 4,
        path: "/profile",
        element: <Profile />,
        private: true,
        title: "Hồ sơ",
    },
];

export default privateRoutes;

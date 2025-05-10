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
        layout: AuthLayout,
        title: "Đăng xuất",
    },
    {
        id: 2,
        path: "/chat-bot",
        element: <Chatbot />,
        layout: AuthLayout,
        title: "Chatbot",
    },
    {
        id: 3,
        path: "/verify-email",
        element: <VerifyEmail />,
        layout: AuthLayout,
        title: "Xác thực email",
    },
    {
        id: 4,
        path: "/profile",
        element: <Profile />,
        layout: AuthLayout,
        title: "Hồ sơ",
    },
];

export default privateRoutes;

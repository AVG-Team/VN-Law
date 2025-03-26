// Desc: Private routes for the application ( require authentication to access )
import SignOut from "~/features/SignOut";
import Chatbot from "~/features/Chatbot";
import VerifyEmail from "~/features/VerifyEmail";
import Profile from "~/features/Profile";
import AuthLayout from "~/components/layout/AuthLayout";

const privateRoutes = [
    {
        path: "/sign-out",
        element: <SignOut />,
        layout: AuthLayout,
        title: "Đăng xuất",
    },
    {
        path: "/chat-bot",
        element: <Chatbot />,
        layout: AuthLayout,
        title: "Chatbot",
    },
    {
        path: "/verify-email",
        element: <VerifyEmail />,
        layout: AuthLayout,
        title: "Xác thực email",
    },
    {
        path: "/profile",
        element: <Profile />,
        layout: AuthLayout,
        title: "Hồ sơ",
    },
];

export default privateRoutes;

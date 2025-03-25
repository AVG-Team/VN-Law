// Desc: Private routes for the application ( require authentication to access )
import SignOut from "~/features/SignOut";
import Chatbot from "~/features/Chatbot";
import VerifyEmail from "~/features/VerifyEmail";
import Profile from "~/features/Profile";

const privateRoutes = [
    {
        path: "/sign-out",
        element: <SignOut />,
        name: "Sign Out",
        title: "Đăng xuất",
    },
    {
        path: "/chat-bot",
        element: <Chatbot />,
        name: "Chatbot",
        title: "Chatbot",
    },
    {
        path: "/verify-email",
        element: <VerifyEmail />,
        name: "Verify Email",
        title: "Xác thực email",
    },
    {
        path: "/profile",
        element: <Profile />,
        name: "Profile",
    },
];

export default privateRoutes;

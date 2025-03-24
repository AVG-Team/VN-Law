// Desc: Private routes for the application ( require authentication to access )
import SignOut from "~/features/SignOut";
import Chatbot from "~/features/Chatbot";
import VerifyEmail from "~/features/VerifyEmail";
import Profile from "~/features/Profile";

const publicRoutes = [
    {
        path: "/sign-out",
        element: <SignOut />,
    },
    {
        path: "/chat-bot",
        element: <Chatbot />,
    },
    {
        path: "/verify-email",
        element: <VerifyEmail />,
    },
    {
        path: "/profile",
        element: <Profile />,
    },
];

export default publicRoutes;

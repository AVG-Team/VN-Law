// Desc: Public routes for the application ( no authentication required to access )
import Home from "../features/Home";
import About from "~/features/About";
import SignUp from "~/features/SignUp";
import VBQPPL from "~/features/VBQPPL";
import SignIn from "~/features/SignIn";
import TreeLaw from "~/features/TreeLaw";
import SignOut from "~/features/SignOut";
import Contact from "~/features/Contact";
import Chatbot from "~/features/Chatbot";
import VerifyEmail from "~/features/VerifyEmail";
import VBBQPPLDetail from "~/features/VBQPPL/detail";
import ForgotPassword from "~/features/ForgotPassword";
import Form from "~/features/Form";
import Notify from "~/features/Notify";
import Confirm from "~/features/Confirm";
import Profile from "~/features/Profile";
import News from "~/features/News";
import Forum from "~/features/Forum";

const publicRoutes = [
    {
        id: 1,
        path: "",
        element: <Home />,
        name: "Home",
    },
    {
        id: 2,
        path: "/about",
        element: <About />,
        name: "About",
    },
    {
        id: 3,
        path: "/sign-up",
        element: <SignUp />,
        name: "Sign Up",
    },
    {
        id: 4,
        path: "/vbqppl",
        element: <VBQPPL />,
        name: "VBQPPL",
    },
    {
        id: 5,
        path: "/sign-in",
        element: <SignIn />,
        name: "Sign In",
    },
    {
        id: 6,
        path: "/tree-law",
        element: <TreeLaw />,
        name: "Tree Law",
    },
    {
        id: 7,
        path: "/contact",
        element: <Contact />,
        name: "Contact",
    },
    {
        id: 8,
        path: "/verify-email",
        element: <VerifyEmail />,
        name: "Verify Email",
    },
    {
        id: 9,
        path: "/vbqppl/:id",
        element: <VBBQPPLDetail />,
        name: "VBQPPL Detail",
    },
    {
        id: 10,
        path: "/forgot-password",
        element: <ForgotPassword />,
        name: "Forgot Password",
    },
    {
        id: 11,
        path: "/form",
        element: <Form />,
        name: "Form",
    },
    {
        id: 12,
        path: "/notify",
        element: <Notify />,
        name: "Notify",
    },
    {
        id: 13,
        path: "/confirm",
        element: <Confirm />,
        name: "Confirm",
    },
    {
        id: 14,
        path: "/news",
        element: <News />,
        name: "News",
    },
    {
        id: 15,
        path: "/forum",
        element: <Forum />,
        name: "Forum",
    },
];

export default publicRoutes;

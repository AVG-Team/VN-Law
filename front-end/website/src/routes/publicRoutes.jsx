// Desc: Public routes for the application ( no authentication required to access )
import Home from "../features/Home";
import About from "~/features/About";
import SignUp from "~/features/SignUp";
import VBQPPL from "~/features/VBQPPL";
import SignIn from "~/features/SignIn";
import TreeLaw from "~/features/TreeLaw";
import Contact from "~/features/Contact";
import VerifyEmail from "~/features/VerifyEmail";
import VBBQPPLDetail from "~/features/VBQPPL/detail";
import ForgotPassword from "~/features/ForgotPassword";
import Form from "~/features/Form";
import Notify from "~/features/Notify";
import Confirm from "~/features/Confirm";
import News from "~/features/News";
import Forum from "~/features/Forum";

const publicRoutes = [
    {
        id: 1,
        path: "",
        element: <Home />,
        name: "Home",
        title: "Trang chủ",
    },
    {
        id: 2,
        path: "/about",
        element: <About />,
        name: "About",
        title: "Giới thiệu",
    },
    {
        id: 3,
        path: "/sign-up",
        element: <SignUp />,
        name: "Sign Up",
        title: "Đăng ký",
    },
    {
        id: 4,
        path: "/vbqppl",
        element: <VBQPPL />,
        name: "VBQPPL",
        title: "Văn bản quy phạm pháp luật",
    },
    {
        id: 5,
        path: "/sign-in",
        element: <SignIn />,
        name: "Sign In",
        title: "Đăng nhập",
    },
    {
        id: 6,
        path: "/tree-law",
        element: <TreeLaw />,
        name: "Tree Law",
        title: "Tra cứu pháp điển",
    },
    {
        id: 7,
        path: "/contact",
        element: <Contact />,
        name: "Contact",
        title: "Liên hệ",
    },
    {
        id: 8,
        path: "/vbqppl/:id",
        element: <VBBQPPLDetail />,
        name: "VBQPPL Detail",
        title: "Chi tiết văn bản quy phạm pháp luật",
    },
    {
        id: 9,
        path: "/forgot-password",
        element: <ForgotPassword />,
        name: "Forgot Password",
        title: "Quên mật khẩu",
    },
    {
        id: 10,
        path: "/form",
        element: <Form />,
        name: "Form",
        title: "Form",
    },
    {
        id: 11,
        path: "/notify",
        element: <Notify />,
        name: "Notify",
        title: "Notify",
    },
    {
        id: 12,
        path: "/confirm",
        element: <Confirm />,
        name: "Confirm",
        title: "Confirm",
    },
    {
        id: 13,
        path: "/tin-tuc",
        element: <News />,
        name: "News",
        title: "Tin tức",
    },
    {
        id: 14,
        path: "/dien-dan",
        element: <Forum />,
        name: "Forum",
        title: "Diễn đàn",
    },
];

export default publicRoutes;

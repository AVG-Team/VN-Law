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
import Login from "~/features/Login";
import Chatbot from "~/features/Chatbot";
import BasicLayout from "~/components/layout/BasicLayout";
import ContentLayout from "~/components/layout/ContentLayout";
import NotFound from "~/components/ui/NotFound";
import Maintenance from "~/components/ui/Maintenance";

const publicRoutes = [
    {
        id: 1,
        path: "",
        element: <Home />,
        title: "Trang chủ",
        layout: BasicLayout,
    },
    {
        id: 2,
        path: "/about",
        element: <About />,
        title: "Giới thiệu",
        layout: ContentLayout,
    },
    {
        id: 3,
        path: "/register",
        element: <SignUp />,
        title: "Đăng ký",
        layout: ContentLayout,
    },
    {
        id: 4,
        path: "/van-ban-quy-pham-phap-luat",
        element: <VBQPPL />,
        title: "Văn bản quy phạm pháp luật",
        layout: ContentLayout,
    },
    {
        id: 5,
        path: "/login",
        element: <Login />,
        title: "Đăng nhập",
        layout: ContentLayout,
    },
    {
        id: 6,
        path: "/phap-dien",
        element: <TreeLaw />,
        title: "Tra cứu pháp điển",
        layout: ContentLayout,
    },
    {
        id: 7,
        path: "/contact",
        element: <Contact />,
        title: "Liên hệ",
        layout: ContentLayout,
    },
    {
        id: 8,
        path: "/van-ban-quy-pham-phap-luat/:param",
        element: <VBBQPPLDetail />,
        title: "Chi tiết văn bản quy phạm pháp luật",
        layout: ContentLayout,
    },
    {
        id: 9,
        path: "/forgot-password",
        element: <ForgotPassword />,
        title: "Quên mật khẩu",
        layout: ContentLayout,
    },
    {
        id: 10,
        path: "/form",
        element: <Form />,
        title: "Form",
        layout: ContentLayout,
    },
    {
        id: 11,
        path: "/notify",
        element: <Notify />,
        title: "Notify",
        layout: ContentLayout,
    },
    {
        id: 12,
        path: "/confirm",
        element: <Confirm />,
        title: "Confirm",
        layout: ContentLayout,
    },
    {
        id: 13,
        path: "/tin-tuc",
        element: <News />,
        title: "Tin tức",
        layout: ContentLayout,
    },
    {
        id: 14,
        path: "/dien-dan",
        element: <Forum />,
        title: "Diễn đàn",
        layout: ContentLayout,
    },
    {
        id: 15,
        path: "/trang-khong-ton-tai",
        element: <NotFound />,
        title: "Trang không tồn tại",
        layout: ContentLayout,
    },
    {
        id: 16,
        path: "/bao-tri",
        element: <Maintenance />,
        title: "Bảo trì",
        layout: ContentLayout,
    },
    {
        id: 17,
        path: "/chatbot",
        element: <Chatbot />,
        title: "Chatbot",
        layout: ContentLayout,
    },
];

export default publicRoutes;

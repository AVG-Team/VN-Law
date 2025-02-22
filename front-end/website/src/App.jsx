import { Suspense, useEffect } from "react";
import loadable from "@loadable/component";
import AuthLayout from "~/shared/layouts/AuthLayout";
import BasicLayout from "~/shared/layouts/BasicLayout";
import { CircularProgress } from "@mui/material";
import ContentLayout from "~/shared/layouts/ContentLayout";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import AOS from "aos";
import "aos/dist/aos.css";

const Home = loadable(() => import("~/features/Home"));
const About = loadable(() => import("~/features/About"));
const SignUp = loadable(() => import("~/features/SignUp"));
const VBQPPL = loadable(() => import("~/features/VBQPPL"));
const SignIn = loadable(() => import("~/features/SignIn"));
const TreeLaw = loadable(() => import("~/features/TreeLaw"));
const SignOut = loadable(() => import("~/features/SignOut"));
const Contact = loadable(() => import("~/features/Contact"));
const Chatbot = loadable(() => import("~/features/Chatbot"));
const VerifyEmail = loadable(() => import("~/features/VerifyEmail"));
const VBBQPPLDetail = loadable(() => import("~/features/VBQPPL/detail"));
const ForgotPassword = loadable(() => import("~/features/ForgotPassword"));
const Form = loadable(() => import("~/features/Form"));
const Notify = loadable(() => import("~/features/Notify"));
const Confirm = loadable(() => import("~/features/Confirm"));
const Profile = loadable(() => import("~/features/Profile"));
const News = loadable(() => import("~/features/News"));
const Forum = loadable(() => import("~/features/Forum"));

function App() {
    useEffect(() => {
        AOS.init();
        AOS.refresh();
    }, []);
    return (
        <BrowserRouter>
            <Routes>
                <Route element={<AuthLayout />}>
                    <Route path="/dang-xuat" element={<SignOut />} />
                    {/* <Route path="/chat-bot" element={<Chatbot />} /> */}
                    <Route
                        path="/chatbot"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Chatbot title="Chat Bot" />
                            </Suspense>
                        }
                    />
                </Route>
                <Route element={<BasicLayout />}>
                    <Route
                        index
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Home title="Trang chủ" />
                            </Suspense>
                        }
                    />
                </Route>
                <Route element={<ContentLayout />}>
                    <Route
                        path="/dien-dan"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Forum title="Diễn đàn" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/tin-tuc"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <News title="Tin Tức" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/gioi-thieu"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <About title="Giới thiệu" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/lien-he"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Contact title="Liên hệ" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/bang-bieu"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Form title="Bảng Biểu" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/van-ban-quy-pham-phap-luat"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <VBQPPL title="Văn Bản Quy Phạm Pháp Luật" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/vbqppl/:param"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <VBBQPPLDetail />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/thong-tin-ca-nhan"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Profile />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/dang-nhap"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <SignIn title="Đăng nhập" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/dang-ky"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <SignUp title="Đăng ký" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/thong-bao"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Notify title="Thông Báo" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/oauth2/redirect"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Confirm title="Đang Xác Minh..." />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/quen-mat-khau"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <ForgotPassword title="Quên Mật Khẩu" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/phap-dien"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <TreeLaw title="Pháp Điển" />
                            </Suspense>
                        }
                    />
                    <Route
                        path="/xac-thuc"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <VerifyEmail />
                            </Suspense>
                        }
                    />
                </Route>
            </Routes>
        </BrowserRouter>
    );
}

export default App;

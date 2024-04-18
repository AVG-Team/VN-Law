import { Suspense } from "react";
import loadable from "@loadable/component";
import AuthLayout from "~/layouts/AuthLayout";
import BasicLayout from "~/layouts/BasicLayout";
import { CircularProgress } from "@mui/material";
import ContentLayout from "~/layouts/ContentLayout";
import UserAuthLayout from "~/layouts/UserAuthLayout";
import { BrowserRouter, Routes, Route } from "react-router-dom";

const Chatbot = loadable(() => import("~/features/Chatbot"));
const Home = loadable(() => import("~/features/Home"));
const About = loadable(() => import("~/features/About"));
const SignOut = loadable(() => import("~/features/SignOut"));
const Contact = loadable(() => import("~/features/Contact"));
const SignIn = loadable(() => import("~/features/SignIn"));
const VBQPPL = loadable(() => import("~/features/VBQPPL"));
const VBBQPPLDetail = loadable(() => import("~/features/VBQPPL/detail"));

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route element={<AuthLayout />}>
                    <Route path="/dang-xuat" element={<SignOut />} />
                    <Route path="/chat-bot" element={<Chatbot />} />
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
                </Route>
                <Route element={<ContentLayout />}>
                    <Route
                        path="/chatbot"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <Chatbot title="Chat Bot" />
                            </Suspense>
                        }
                    />
                </Route>
                <Route element={<UserAuthLayout />}>
                    <Route
                        path="/dang-nhap"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <SignIn title="Đăng nhập" />
                            </Suspense>
                        }
                    />
                </Route>
            </Routes>
        </BrowserRouter>
    );
}

export default App;

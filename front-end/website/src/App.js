import { Suspense } from "react";
import loadable from "@loadable/component";
import AuthLayout from "~/layouts/AuthLayout";
import BasicLayout from "~/layouts/BasicLayout";
import ContentLayout from "~/layouts/ContentLayout";
import { CircularProgress } from "@mui/material";
import { BrowserRouter, Routes, Route } from "react-router-dom";

const Home = loadable(() => import("~/features/Home"));
const About = loadable(() => import("~/features/About"));
const TreeLaw = loadable(() => import("~/features/TreeLaw"));
const Chatbot = loadable(() => import("~/features/Chatbot"));
const SignOut = loadable(() => import("~/features/SignOut"));

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
                <Route element={<ContentLayout />}>
                    <Route
                        path="/danh-sach-van-ban-phap-luat"
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <TreeLaw title="Danh sách văn bản pháp luật" />
                            </Suspense>
                        }
                    />
                </Route>
            </Routes>
        </BrowserRouter>
    );
}

export default App;

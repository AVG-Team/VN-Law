import { Suspense } from "react";
import loadable from "@loadable/component";
import AuthLayout from "~/layouts/AuthLayout";
import BasicLayout from "~/layouts/BasicLayout";
import { CircularProgress } from "@mui/material";
import { BrowserRouter, Routes, Route } from "react-router-dom";

const Chatbot = loadable(() => import("~/features/Chatbot"));
const Home = loadable(() => import("~/features/Home"));
const About = loadable(() => import("~/features/About"));
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
                        index
                        element={
                            <Suspense fallback={<CircularProgress />}>
                                <About title="Giới thiệu" />
                            </Suspense>
                        }
                    />
                </Route>
            </Routes>
        </BrowserRouter>
    );
}

export default App;

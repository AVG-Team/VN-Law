import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Preloader from "./components/ui/Preloader";
import AuthLayout from "~/components/layout/AuthLayout";
import BasicLayout from "~/components/layout/BasicLayout";
import routes from "~/routes";
import AOS from "aos";
import "aos/dist/aos.css";
import "./App.css";
import { isTokenExpired } from "./mock/auth";
import { use } from "react";

const App = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [message, setMessage] = useState("");
    const [sessionExpired, setSessionExpired] = useState(false);

    // Check if the session has expired
    useEffect(() => {
        const token = localStorage.getItem("access_token");

        if (token && isTokenExpired(token)) {
            setSessionExpired(true);
        }
    }, []);
    useEffect(() => {
        if (sessionExpired) {
            // Hiển thị modal cảnh báo
            Modal.warning({
                title: "Phiên đăng nhập đã hết hạn",
                content: "Vui lòng đăng nhập lại để tiếp tục sử dụng.",
                centered: true,
                maskClosable: false,
            });

            const timer = setTimeout(() => {
                localStorage.clear();
                window.location.href = "/dang-nhap";
            }, 15000); // 15s

            return () => clearTimeout(timer);
        }
    }, [sessionExpired]);

    useEffect(() => {
        AOS.init();
        AOS.refresh();

        // Hide all other components during loading
        const timer = setTimeout(() => {
            setIsLoading(false);
        }, 5000);

        return () => clearTimeout(timer);
    }, []);

    const handleCrawl = async () => {
        try {
            const response = await fetch("http://localhost:5000/api/crawl", {
                method: "POST",
            });
            const data = await response.json();
            setMessage(data.message);
        } catch (error) {
            setMessage("Error: " + error.message);
        }
    };

    const handleTestCrawl = async () => {
        try {
            const response = await fetch("http://localhost:5000/api/test-crawl", {
                method: "POST",
            });
            const data = await response.json();
            setMessage(data.message);
        } catch (error) {
            setMessage("Error: " + error.message);
        }
    };

    return (
        <Router>
            {isLoading ? (
                <Preloader />
            ) : (
                <div className="App">
                    {message && <p className="message">{message}</p>}
                    <Routes>
                        {routes.map((route) => {
                            const Layout = route.private ? AuthLayout : BasicLayout;
                            return (
                                <Route
                                    key={route.id}
                                    path={route.path}
                                    element={<Layout element={route.element} title={route.title} />}
                                />
                            );
                        })}
                    </Routes>
                </div>
            )}
        </Router>
    );
};

export default App;

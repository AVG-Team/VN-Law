import React, { useState, useEffect } from "react";
import { BrowserRouter as Router } from "react-router-dom";
import Preloader from "./components/Preloader";
import AppRoutes from "./routes";
import { Suspense } from "react";
import AuthLayout from "~/components/layout/AuthLayout";
import BasicLayout from "~/components/layout/BasicLayout";
import routes from "~/routes";
import ContentLayout from "~/components/layout/ContentLayout";
import { Routes, Route } from "react-router-dom";
import AOS from "aos";
import "aos/dist/aos.css";

const App = () => {
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        AOS.init();
        AOS.refresh();

        // Hide all other components during loading
        const timer = setTimeout(() => {
            setIsLoading(false);
        }, 2000);

        return () => clearTimeout(timer);
    }, []);

    return (
        <Router>
            <Preloader />
            <Routes>
                {routes.map((route) => {
                    const Layout = route.private ? AuthLayout : BasicLayout;
                    return <Route key={route.id} path={route.path} element={<Layout element={route.element} />} />;
                })}
            </Routes>
        </Router>
    );
};

export default App;

import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Preloader from "./components/ui/Preloader";
import AuthLayout from "~/components/layout/AuthLayout";
import BasicLayout from "~/components/layout/BasicLayout";
import routes from "~/routes";
import AOS from "aos";
import "aos/dist/aos.css";
import './App.css';

const App = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [message, setMessage] = useState('');

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
            const response = await fetch('http://localhost:5000/api/crawl', {
                method: 'POST',
            });
            const data = await response.json();
            setMessage(data.message);
        } catch (error) {
            setMessage('Error: ' + error.message);
        }
    };

    const handleTestCrawl = async () => {
        try {
            const response = await fetch('http://localhost:5000/api/test-crawl', {
                method: 'POST',
            });
            const data = await response.json();
            setMessage(data.message);
        } catch (error) {
            setMessage('Error: ' + error.message);
        }
    };

    return (
        <Router>
            {isLoading ? (
                <Preloader />
            ) : (
                <div className="App">
                    <h1>Crawl Data Control Panel</h1>
                    <div className="button-container">
                        <button onClick={handleCrawl}>Start Crawl Data</button>
                        <button onClick={handleTestCrawl}>Start Test Crawl</button>
                    </div>
                    {message && <p className="message">{message}</p>}
                    <Routes>
                        {routes.map((route) => {
                            const Layout = route.private ? AuthLayout : BasicLayout;
                            return <Route key={route.id} path={route.path} element={<Layout element={route.element} />} />;
                        })}
                    </Routes>
                </div>
            )}
        </Router>
    );
};

export default App;

import React from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import { Button } from "@mui/material";
import ErrorOutlineIcon from "@mui/icons-material/ErrorOutline";

class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false, error: null };
    }

    static getDerivedStateFromError(error) {
        return { hasError: true, error };
    }

    componentDidCatch(error, errorInfo) {
        console.error("Error caught by boundary:", error, errorInfo);
    }

    render() {
        if (this.state.hasError) {
            return (
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    className="flex flex-col items-center justify-center min-h-[400px] p-8 text-center"
                >
                    <ErrorOutlineIcon className="w-16 h-16 mb-4 text-red-500" />
                    <h2 className="mb-2 text-2xl font-bold text-gray-900">Đã xảy ra lỗi</h2>
                    <p className="mb-6 text-gray-600">{this.state.error?.message || "Vui lòng thử lại sau"}</p>
                    <Button variant="contained" color="primary" onClick={() => window.location.reload()}>
                        Thử lại
                    </Button>
                </motion.div>
            );
        }

        return this.props.children;
    }
}

ErrorBoundary.propTypes = {
    children: PropTypes.node.isRequired,
};

export default ErrorBoundary;

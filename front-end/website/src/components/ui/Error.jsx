import React from "react";
import { RefreshCw, Home, ArrowLeft, AlertTriangle, Wifi, Server, Shield } from "lucide-react";
import PropTypes from "prop-types"; // Thêm PropTypes nếu không dùng TypeScript

const ErrorPage = ({
    errorCode = "500",
    title = "Đã xảy ra lỗi",
    description = "Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau.",
    showRetryButton = true,
    showHomeButton = true,
    showBackButton = false,
    onRetry,
    onGoHome,
    onGoBack,
    errorType = "general", // "network", "server", "403", "404", "500"
}) => {
    const getErrorIcon = () => {
        const iconClass = "w-24 h-24 mx-auto mb-6";

        switch (errorType) {
            case "network":
                return <Wifi className={`${iconClass} text-orange-500`} />;
            case "server":
                return <Server className={`${iconClass} text-red-500`} />;
            case "403":
                return <Shield className={`${iconClass} text-yellow-500`} />;
            case "404":
                return <div className="mb-6 text-6xl font-bold text-gray-400">404</div>;
            default:
                return <AlertTriangle className={`${iconClass} text-red-500`} />;
        }
    };

    const getErrorTheme = () => {
        switch (errorType) {
            case "network":
                return {
                    bgGradient: "from-orange-50 to-orange-100",
                    buttonPrimary: "bg-orange-500 hover:bg-orange-600",
                    buttonSecondary: "border-orange-300 text-orange-600 hover:bg-orange-50",
                };
            case "403":
                return {
                    bgGradient: "from-yellow-50 to-yellow-100",
                    buttonPrimary: "bg-yellow-500 hover:bg-yellow-600",
                    buttonSecondary: "border-yellow-300 text-yellow-600 hover:bg-yellow-50",
                };
            case "404":
                return {
                    bgGradient: "from-blue-50 to-blue-100",
                    buttonPrimary: "bg-blue-500 hover:bg-blue-600",
                    buttonSecondary: "border-blue-300 text-blue-600 hover:bg-blue-50",
                };
            default:
                return {
                    bgGradient: "from-red-50 to-red-100",
                    buttonPrimary: "bg-red-500 hover:bg-red-600",
                    buttonSecondary: "border-red-300 text-red-600 hover:bg-red-50",
                };
        }
    };

    const theme = getErrorTheme();

    return (
        <div className={`min-h-screen bg-gradient-to-br ${theme.bgGradient} flex items-center justify-center px-4`}>
            <div className="w-full max-w-md">
                {/* Error illustration */}
                <div className="mb-8 text-center">
                    {getErrorIcon()}

                    {/* Error code */}
                    {errorCode && errorType !== "404" && (
                        <div className="mb-2 text-3xl font-bold text-gray-600">{errorCode}</div>
                    )}
                </div>

                {/* Error content */}
                <div className="p-8 text-center bg-white shadow-xl rounded-2xl">
                    <h1 className="mb-4 text-2xl font-bold text-gray-800">{title}</h1>

                    <p className="mb-8 leading-relaxed text-gray-600">{description}</p>

                    {/* Action buttons */}
                    <div className="space-y-3">
                        {showRetryButton && (
                            <button
                                onClick={onRetry}
                                className={`w-full ${theme.buttonPrimary} text-white font-medium py-3 px-6 rounded-lg transition-colors duration-200 flex items-center justify-center gap-2`}
                            >
                                <RefreshCw className="w-5 h-5" />
                                Thử lại
                            </button>
                        )}

                        <div className="flex gap-3">
                            {showBackButton && (
                                <button
                                    onClick={onGoBack}
                                    className={`flex-1 border-2 ${theme.buttonSecondary} font-medium py-3 px-6 rounded-lg transition-colors duration-200 flex items-center justify-center gap-2`}
                                >
                                    <ArrowLeft className="w-5 h-5" />
                                    Quay lại
                                </button>
                            )}

                            {showHomeButton && (
                                <button
                                    onClick={onGoHome}
                                    className={`flex-1 border-2 ${theme.buttonSecondary} font-medium py-3 px-6 rounded-lg transition-colors duration-200 flex items-center justify-center gap-2`}
                                >
                                    <Home className="w-5 h-5" />
                                    Trang chủ
                                </button>
                            )}
                        </div>
                    </div>
                </div>

                {/* Additional help text */}
                <div className="mt-6 text-sm text-center text-gray-500">
                    Nếu vấn đề vẫn tiếp tục, vui lòng liên hệ với bộ phận hỗ trợ
                </div>
            </div>
        </div>
    );
};

// Kiểm tra prop types (nếu không dùng TypeScript)
ErrorPage.propTypes = {
    errorCode: PropTypes.string,
    title: PropTypes.string,
    description: PropTypes.string,
    showRetryButton: PropTypes.bool,
    showHomeButton: PropTypes.bool,
    showBackButton: PropTypes.bool,
    onRetry: PropTypes.func,
    onGoHome: PropTypes.func,
    onGoBack: PropTypes.func,
    errorType: PropTypes.string,
};

export default ErrorPage;

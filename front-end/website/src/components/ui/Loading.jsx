import React from "react";
import { Loader2 } from "lucide-react";

// Component Loading chính
export default function LoadingComponent({
    size = "medium",
    text = "Đang tải...",
    showText = true,
    variant = "spinner",
    fullscreen = false,
}) {
    const sizeClasses = {
        small: "w-4 h-4",
        medium: "w-6 h-6",
        large: "w-8 h-8",
    };

    const textSizes = {
        small: "text-sm",
        medium: "text-base",
        large: "text-lg",
    };

    // Spinner loading
    const SpinnerContent = () => (
        <div className="flex flex-col items-center justify-center space-y-3">
            <Loader2 className={`${sizeClasses[size]} animate-spin text-blue-600`} />
            {showText && <span className={`${textSizes[size]} text-gray-600`}>{text}</span>}
        </div>
    );

    // Dots loading
    const DotsContent = () => (
        <div className="flex flex-col items-center justify-center space-y-3">
            <div className="flex space-x-1">
                <div
                    className={`${
                        size === "small" ? "w-2 h-2" : size === "large" ? "w-4 h-4" : "w-3 h-3"
                    } bg-blue-600 rounded-full animate-bounce`}
                ></div>
                <div
                    className={`${
                        size === "small" ? "w-2 h-2" : size === "large" ? "w-4 h-4" : "w-3 h-3"
                    } bg-blue-600 rounded-full animate-bounce`}
                    style={{ animationDelay: "0.1s" }}
                ></div>
                <div
                    className={`${
                        size === "small" ? "w-2 h-2" : size === "large" ? "w-4 h-4" : "w-3 h-3"
                    } bg-blue-600 rounded-full animate-bounce`}
                    style={{ animationDelay: "0.2s" }}
                ></div>
            </div>
            {showText && <span className={`${textSizes[size]} text-gray-600`}>{text}</span>}
        </div>
    );

    // Pulse loading
    const PulseContent = () => (
        <div className="flex flex-col items-center justify-center space-y-3">
            <div className={`${sizeClasses[size]} bg-blue-600 rounded-full animate-pulse`}></div>
            {showText && <span className={`${textSizes[size]} text-gray-600`}>{text}</span>}
        </div>
    );

    // Render content based on variant
    let content;
    if (variant === "dots") {
        content = <DotsContent />;
    } else if (variant === "pulse") {
        content = <PulseContent />;
    } else {
        content = <SpinnerContent />;
    }

    // Fullscreen overlay for API loading
    if (fullscreen) {
        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center bg-white/80 backdrop-blur-sm">
                {content}
            </div>
        );
    }

    // Regular inline loading
    return content;
}

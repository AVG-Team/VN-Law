import React, { useState, useEffect } from "react";
import { Settings, Clock, Home, RefreshCw, AlertTriangle, CheckCircle, Wrench, Cog } from "lucide-react";
import { useNavigate } from "react-router-dom";

export default function Maintenance() {
    const [progress, setProgress] = useState(0);
    const [currentTime, setCurrentTime] = useState(new Date());
    const [isVisible, setIsVisible] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        setIsVisible(true);

        // Progress bar animation
        const progressInterval = setInterval(() => {
            setProgress((prev) => {
                if (prev >= 100) return 0;
                return prev + Math.random() * 3;
            });
        }, 200);

        // Clock update
        const timeInterval = setInterval(() => {
            setCurrentTime(new Date());
        }, 1000);

        return () => {
            clearInterval(progressInterval);
            clearInterval(timeInterval);
        };
    }, []);

    const maintenanceSteps = [
        { icon: CheckCircle, text: "Sao lưu dữ liệu", completed: true },
        { icon: RefreshCw, text: "Cập nhật hệ thống", inProgress: true },
        { icon: Cog, text: "Tối ưu hiệu suất", completed: false },
        { icon: CheckCircle, text: "Kiểm tra bảo mật", completed: false },
    ];

    const floatingIcons = [
        { icon: Settings, delay: 0, position: "top-16 left-16" },
        { icon: Wrench, delay: 0.5, position: "top-20 right-20" },
        { icon: Wrench, delay: 1, position: "bottom-32 left-24" },
        { icon: RefreshCw, delay: 1.5, position: "bottom-16 right-16" },
    ];

    return (
        <div className="relative min-h-screen overflow-hidden bg-gradient-to-br from-slate-100 via-blue-400 to-sky-400">
            {/* Animated Grid Background */}
            <div className="absolute inset-0 opacity-5">
                <div className="grid w-full h-full grid-cols-12 grid-rows-12">
                    {Array.from({ length: 144 }).map((_, i) => (
                        <div
                            key={i}
                            className="border border-blue-400 animate-pulse"
                            style={{
                                animationDelay: `${i * 0.05}s`,
                                animationDuration: "4s",
                            }}
                        />
                    ))}
                </div>
            </div>

            {/* Floating Technical Icons */}
            {floatingIcons.map(({ icon: Icon, delay, position }, index) => (
                <div
                    key={index}
                    className={`absolute ${position} opacity-20 animate-float`}
                    style={{
                        animationDelay: `${delay}s`,
                    }}
                >
                    <Icon size={40} className="text-blue-300 animate-spin" style={{ animationDuration: "8s" }} />
                </div>
            ))}

            {/* Main Content */}
            <div className="relative z-10 flex items-center justify-center min-h-screen p-4">
                <div
                    className={`text-center max-w-4xl mx-auto transition-all duration-1000 ${
                        isVisible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-10"
                    }`}
                >
                    {/* Main Icon with Pulse Effect */}
                    <div className="flex justify-center mb-8">
                        <div className="relative">
                            <div className="absolute inset-0 scale-150 bg-orange-500 rounded-full opacity-50 blur-xl animate-pulse"></div>
                            <div className="relative p-8 rounded-full bg-gradient-to-r from-orange-500 to-red-500 animate-bounce">
                                <Settings
                                    size={80}
                                    className="text-white animate-spin"
                                    style={{ animationDuration: "3s" }}
                                />
                            </div>
                        </div>
                    </div>

                    {/* Title */}
                    <h1 className="mb-4 text-4xl font-bold text-white md:text-6xl animate-fade-in-up">
                        <span className="text-transparent bg-gradient-to-r from-orange-400 to-red-500 bg-clip-text">
                            Hệ Thống Đang
                        </span>
                        <br />
                        <span className="text-transparent bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text">
                            Được Cập Nhật
                        </span>
                    </h1>

                    {/* Subtitle */}
                    <p className="mb-8 text-xl text-blue-200 md:text-2xl animate-fade-in-up animation-delay-300">
                        Chúng tôi đang nâng cấp hệ thống để mang đến trải nghiệm tốt hơn
                    </p>

                    {/* Progress Bar */}
                    <div className="mb-8 animate-fade-in-up animation-delay-600">
                        <div className="p-6 border bg-slate-800/50 backdrop-blur-lg rounded-2xl border-blue-500/30">
                            <div className="flex items-center justify-between mb-4">
                                <span className="font-semibold text-blue-300">Tiến độ cập nhật</span>
                                <span className="font-bold text-orange-400">{Math.round(progress)}%</span>
                            </div>
                            <div className="w-full h-4 overflow-hidden rounded-full bg-slate-700">
                                <div
                                    className="relative h-full transition-all duration-300 rounded-full bg-gradient-to-r from-orange-500 to-red-500"
                                    style={{ width: `${Math.min(progress, 100)}%` }}
                                >
                                    <div className="absolute inset-0 bg-white/20 animate-pulse"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Maintenance Steps */}
                    <div className="mb-8 animate-fade-in-up animation-delay-900">
                        <div className="p-6 border bg-slate-800/50 backdrop-blur-lg rounded-2xl border-blue-500/30">
                            <h3 className="flex items-center justify-center mb-6 text-xl font-semibold text-white">
                                <Wrench className="mr-3 text-orange-400" size={24} />
                                Quy trình bảo trì
                            </h3>
                            <div className="space-y-4">
                                {maintenanceSteps.map((step, index) => (
                                    <div
                                        key={index}
                                        className="flex items-center p-3 space-x-4 rounded-lg bg-slate-700/30"
                                    >
                                        <step.icon
                                            size={24}
                                            className={`${
                                                step.completed
                                                    ? "text-green-400"
                                                    : step.inProgress
                                                    ? "text-orange-400 animate-spin"
                                                    : "text-gray-400"
                                            }`}
                                        />
                                        <span
                                            className={`${
                                                step.completed
                                                    ? "text-green-300"
                                                    : step.inProgress
                                                    ? "text-orange-300"
                                                    : "text-gray-300"
                                            }`}
                                        >
                                            {step.text}
                                        </span>
                                        {step.inProgress && (
                                            <div className="flex ml-auto space-x-1">
                                                <div className="w-2 h-2 bg-orange-400 rounded-full animate-bounce"></div>
                                                <div className="w-2 h-2 bg-orange-400 rounded-full animate-bounce animation-delay-200"></div>
                                                <div className="w-2 h-2 bg-orange-400 rounded-full animate-bounce animation-delay-400"></div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>

                    {/* Current Time */}
                    <div className="mb-8 animate-fade-in-up animation-delay-1200">
                        <div className="inline-block p-4 border bg-slate-800/50 backdrop-blur-lg rounded-xl border-blue-500/30">
                            <div className="flex items-center space-x-3">
                                <Clock className="text-blue-400 animate-pulse" size={20} />
                                <span className="text-blue-200">
                                    {currentTime.toLocaleString("vi-VN", {
                                        weekday: "long",
                                        year: "numeric",
                                        month: "long",
                                        day: "numeric",
                                        hour: "2-digit",
                                        minute: "2-digit",
                                        second: "2-digit",
                                    })}
                                </span>
                            </div>
                        </div>
                    </div>

                    {/* Action Button */}
                    <div className="animate-fade-in-up animation-delay-1500">
                        <button
                            onClick={() => navigate("/")}
                            className="flex items-center px-10 py-4 mx-auto font-semibold text-white transition-all duration-300 transform group bg-gradient-to-r from-blue-600 to-indigo-700 hover:from-blue-500 hover:to-indigo-600 rounded-xl hover:scale-105 hover:shadow-2xl hover:shadow-blue-500/25"
                        >
                            <Home className="mr-3 group-hover:animate-bounce" size={24} />
                            Quay Lại Trang Chủ
                        </button>
                    </div>

                    {/* Contact Info */}
                    <div className="mt-12 animate-fade-in-up animation-delay-1800">
                        <div className="p-6 border bg-slate-800/30 backdrop-blur-lg rounded-xl border-yellow-500/30">
                            <div className="flex items-center justify-center mb-4">
                                <AlertTriangle className="mr-3 text-yellow-400" size={24} />
                                <span className="font-semibold text-yellow-300">Thông tin quan trọng</span>
                            </div>
                            <p className="leading-relaxed text-gray-300">
                                Thời gian dự kiến hoàn thành:{" "}
                                <span className="font-semibold text-orange-400">2-3 giờ</span>
                                <br />
                                Trong thời gian này, một số tính năng có thể tạm thời không khả dụng.
                                <br />
                                Cảm ơn bạn đã kiên nhẫn chờ đợi!
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Animated Particles */}
            <div className="absolute inset-0 overflow-hidden pointer-events-none">
                {Array.from({ length: 15 }).map((_, i) => (
                    <div
                        key={i}
                        className="absolute w-3 h-3 bg-orange-400 rounded-full opacity-20 animate-float"
                        style={{
                            left: `${Math.random() * 100}%`,
                            top: `${Math.random() * 100}%`,
                            animationDelay: `${Math.random() * 4}s`,
                            animationDuration: `${4 + Math.random() * 2}s`,
                        }}
                    />
                ))}
            </div>

            <style jsx>{`
                @keyframes fade-in-up {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                @keyframes float {
                    0%,
                    100% {
                        transform: translateY(0px) rotate(0deg);
                    }
                    33% {
                        transform: translateY(-15px) rotate(120deg);
                    }
                    66% {
                        transform: translateY(8px) rotate(240deg);
                    }
                }

                .animate-fade-in-up {
                    animation: fade-in-up 0.8s ease-out forwards;
                }

                .animate-float {
                    animation: float 5s ease-in-out infinite;
                }

                .animation-delay-200 {
                    animation-delay: 0.2s;
                }

                .animation-delay-300 {
                    animation-delay: 0.3s;
                }

                .animation-delay-400 {
                    animation-delay: 0.4s;
                }

                .animation-delay-600 {
                    animation-delay: 0.6s;
                }

                .animation-delay-900 {
                    animation-delay: 0.9s;
                }

                .animation-delay-1200 {
                    animation-delay: 1.2s;
                }

                .animation-delay-1500 {
                    animation-delay: 1.5s;
                }

                .animation-delay-1800 {
                    animation-delay: 1.8s;
                }
            `}</style>
        </div>
    );
}

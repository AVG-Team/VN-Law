import React, { useState, useEffect } from "react";
import { Scale, BookOpen, Home, Search, FileText, AlertCircle, ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

export default function NotFound() {
    const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
    const [isVisible, setIsVisible] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        setIsVisible(true);
        const handleMouseMove = (e) => {
            setMousePosition({ x: e.clientX, y: e.clientY });
        };
        window.addEventListener("mousemove", handleMouseMove);
        return () => window.removeEventListener("mousemove", handleMouseMove);
    }, []);

    const floatingElements = [
        { icon: Scale, delay: 0, position: "top-20 left-20" },
        { icon: BookOpen, delay: 0.5, position: "top-32 right-32" },
        { icon: FileText, delay: 1, position: "bottom-40 left-16" },
        { icon: AlertCircle, delay: 1.5, position: "bottom-20 right-20" },
    ];

    return (
        <div className="relative min-h-screen overflow-hidden bg-gradient-to-br from-slate-900 via-blue-900 to-indigo-900">
            {/* Animated Background Grid */}
            <div className="absolute inset-0 opacity-10">
                <div className="grid w-full h-full grid-cols-8 grid-rows-8">
                    {Array.from({ length: 64 }).map((_, i) => (
                        <div
                            key={i}
                            className="border border-blue-400 animate-pulse"
                            style={{
                                animationDelay: `${i * 0.1}s`,
                                animationDuration: "3s",
                            }}
                        />
                    ))}
                </div>
            </div>

            {/* Floating Legal Icons */}
            {floatingElements.map(({ icon: Icon, delay, position }, index) => (
                <div
                    key={index}
                    className={`absolute ${position} opacity-20 animate-bounce`}
                    style={{
                        animationDelay: `${delay}s`,
                        animationDuration: "4s",
                        transform: `translate(${(mousePosition.x - window.innerWidth / 2) * 0.01}px, ${
                            (mousePosition.y - window.innerHeight / 2) * 0.01
                        }px)`,
                    }}
                >
                    <Icon size={48} className="text-blue-300" />
                </div>
            ))}

            {/* Main Content */}
            <div className="relative z-10 flex items-center justify-center min-h-screen p-4">
                <div
                    className={`text-center max-w-4xl mx-auto transition-all duration-1000 ${
                        isVisible ? "opacity-100 translate-y-0" : "opacity-0 translate-y-10"
                    }`}
                >
                    {/* 404 Number with Glow Effect */}
                    <div className="relative mb-8">
                        <div className="text-9xl md:text-[12rem] font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-purple-500 to-pink-500 animate-pulse">
                            404
                        </div>
                        <div className="absolute inset-0 text-9xl md:text-[12rem] font-bold text-blue-500 opacity-30 blur-lg animate-pulse">
                            404
                        </div>
                    </div>

                    {/* Scale of Justice Animation */}
                    <div className="flex justify-center mb-8">
                        <div className="relative">
                            <Scale
                                size={120}
                                className="text-yellow-400 animate-swing drop-shadow-2xl"
                                style={{
                                    filter: "drop-shadow(0 0 20px rgba(251, 191, 36, 0.5))",
                                    animation: "swing 2s ease-in-out infinite",
                                }}
                            />
                            <div className="absolute bg-yellow-400 rounded-full -inset-4 opacity-20 blur-xl animate-pulse"></div>
                        </div>
                    </div>

                    {/* Title with Typewriter Effect */}
                    <h1 className="mb-6 text-4xl font-bold text-white md:text-6xl animate-fade-in-up">
                        <span className="text-transparent bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text">
                            Trang Không Tồn Tại
                        </span>
                    </h1>

                    {/* Subtitle */}
                    <p className="mb-8 text-xl text-blue-200 md:text-2xl animate-fade-in-up animation-delay-300">
                        Điều khoản pháp luật bạn tìm kiếm không được tìm thấy trong hệ thống
                    </p>

                    {/* Decorative Line */}
                    <div className="w-32 h-1 mx-auto mb-8 bg-gradient-to-r from-transparent via-yellow-400 to-transparent animate-pulse"></div>

                    {/* Error Message */}
                    <div className="p-6 mb-8 border bg-slate-800/50 backdrop-blur-lg rounded-2xl border-blue-500/30 animate-fade-in-up animation-delay-600">
                        <div className="flex items-center justify-center mb-4 text-blue-300">
                            <AlertCircle className="mr-3 animate-pulse" size={24} />
                            <span className="text-lg font-semibold">Thông Báo Lỗi</span>
                        </div>
                        <p className="leading-relaxed text-gray-300">
                            Trang web bạn đang tìm kiếm có thể đã được di chuyển, xóa hoặc URL không chính xác. Vui lòng
                            kiểm tra lại đường dẫn hoặc sử dụng các liên kết bên dưới để tiếp tục.
                        </p>
                    </div>

                    {/* Action Buttons */}
                    <div className="flex flex-wrap justify-center gap-4 animate-fade-in-up animation-delay-900">
                        <button
                            onClick={() => navigate("/")}
                            className="flex items-center px-8 py-4 font-semibold text-white transition-all duration-300 transform group bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-500 hover:to-blue-600 rounded-xl hover:scale-105 hover:shadow-2xl hover:shadow-blue-500/25"
                        >
                            <Home className="mr-2 group-hover:animate-bounce" size={20} />
                            Trang Chủ
                        </button>
                        <button className="flex items-center px-8 py-4 font-semibold text-white transition-all duration-300 transform group bg-gradient-to-r from-gray-600 to-gray-700 hover:from-gray-500 hover:to-gray-600 rounded-xl hover:scale-105 hover:shadow-2xl hover:shadow-gray-500/25">
                            <ArrowLeft
                                className="mr-2 transition-transform duration-300 group-hover:-translate-x-1"
                                size={20}
                            />
                            Quay Lại
                        </button>
                    </div>

                    {/* Legal Quote */}
                    <div className="mt-12 animate-fade-in-up animation-delay-1200">
                        <blockquote className="max-w-2xl pl-6 mx-auto text-lg italic text-blue-200 border-l-4 border-yellow-400">
                            "Pháp luật là nền tảng của một xã hội công bằng và văn minh"
                        </blockquote>
                        <cite className="block mt-2 text-sm text-gray-400">- Tri thức Pháp luật Việt Nam</cite>
                    </div>
                </div>
            </div>

            {/* Animated Particles */}
            <div className="absolute inset-0 overflow-hidden pointer-events-none">
                {Array.from({ length: 20 }).map((_, i) => (
                    <div
                        key={i}
                        className="absolute w-2 h-2 bg-blue-400 rounded-full opacity-30 animate-float"
                        style={{
                            left: `${Math.random() * 100}%`,
                            top: `${Math.random() * 100}%`,
                            animationDelay: `${Math.random() * 3}s`,
                            animationDuration: `${3 + Math.random() * 2}s`,
                        }}
                    />
                ))}
            </div>

            <style jsx>{`
                @keyframes swing {
                    0%,
                    100% {
                        transform: rotate(-3deg);
                    }
                    50% {
                        transform: rotate(3deg);
                    }
                }

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
                        transform: translateY(-10px) rotate(120deg);
                    }
                    66% {
                        transform: translateY(5px) rotate(240deg);
                    }
                }

                .animate-fade-in-up {
                    animation: fade-in-up 0.8s ease-out forwards;
                }

                .animate-swing {
                    animation: swing 2s ease-in-out infinite;
                }

                .animate-float {
                    animation: float 4s ease-in-out infinite;
                }

                .animation-delay-300 {
                    animation-delay: 0.3s;
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
            `}</style>
        </div>
    );
}

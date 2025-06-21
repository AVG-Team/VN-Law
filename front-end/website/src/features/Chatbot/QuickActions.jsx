import React, { useState, useEffect } from "react";
import {
    DocumentTextIcon,
    MagnifyingGlassIcon,
    QuestionMarkCircleIcon,
    PencilSquareIcon,
    BookOpenIcon,
    PhoneIcon,
    ScaleIcon,
    BanknotesIcon,
    SparklesIcon,
} from "@heroicons/react/24/outline";
import { motion } from "framer-motion";
// import chatbotApi from "../services/chatbotApi";

const QuickActions = ({ onActionClick }) => {
    const [suggestions, setSuggestions] = useState([]);
    const [loading, setLoading] = useState(true);

    // useEffect(() => {
    //     const loadSuggestions = async () => {
    //         try {
    //             const data = await chatbotApi.getSuggestions();
    //             setSuggestions(data);
    //         } catch (error) {
    //             console.error("Failed to load suggestions:", error);
    //             // Fallback to default suggestions
    //             setSuggestions(defaultActions);
    //         } finally {
    //             setLoading(false);
    //         }
    //     };

    //     loadSuggestions();
    // }, []);

    const defaultActions = [
        {
            icon: <MagnifyingGlassIcon className="w-6 h-6" />,
            title: "Tra cứu văn bản",
            description: "Tìm kiếm các văn bản pháp luật",
            prompt: "Tôi muốn tra cứu văn bản pháp luật về",
            color: "from-blue-500 to-blue-600",
            bgColor: "bg-blue-50",
            category: "search",
        },
        {
            icon: <QuestionMarkCircleIcon className="w-6 h-6" />,
            title: "Giải thích điều luật",
            description: "Hiểu rõ nội dung pháp lý",
            prompt: "Bạn có thể giải thích cho tôi về",
            color: "from-green-500 to-green-600",
            bgColor: "bg-green-50",
            category: "explain",
        },
        {
            icon: <PencilSquareIcon className="w-6 h-6" />,
            title: "Soạn thảo văn bản",
            description: "Hỗ trợ viết các loại văn bản pháp lý",
            prompt: "Tôi cần hỗ trợ soạn thảo",
            color: "from-purple-500 to-purple-600",
            bgColor: "bg-purple-50",
            category: "draft",
        },
        {
            icon: <DocumentTextIcon className="w-6 h-6" />,
            title: "Quy trình pháp lý",
            description: "Hướng dẫn các thủ tục cần thiết",
            prompt: "Quy trình thực hiện thủ tục",
            color: "from-orange-500 to-orange-600",
            bgColor: "bg-orange-50",
            category: "process",
        },
        {
            icon: <ScaleIcon className="w-6 h-6" />,
            title: "Tư vấn pháp luật",
            description: "Được tư vấn miễn phí",
            prompt: "Tôi có vấn đề pháp lý về",
            color: "from-red-500 to-red-600",
            bgColor: "bg-red-50",
            category: "consult",
        },
        {
            icon: <PhoneIcon className="w-6 h-6" />,
            title: "Liên hệ luật sư",
            description: "Kết nối với chuyên gia",
            prompt: "Tôi cần tư vấn trực tiếp từ luật sư về",
            color: "from-indigo-500 to-indigo-600",
            bgColor: "bg-indigo-50",
            category: "contact",
        },
    ];

    const actions = suggestions.length > 0 ? suggestions : defaultActions;

    if (loading) {
        return (
            <div className="grid grid-cols-1 gap-4 mb-8 sm:grid-cols-2 lg:grid-cols-3">
                {[...Array(6)].map((_, index) => (
                    <div key={index} className="h-32 p-6 bg-gray-100 animate-pulse rounded-xl"></div>
                ))}
            </div>
        );
    }

    return (
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} className="mb-8">
            <div className="mb-6 text-center">
                <motion.div
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.1 }}
                >
                    <SparklesIcon className="w-12 h-12 mx-auto mb-4 text-blue-600" />
                    <h3 className="mb-2 text-2xl font-bold text-gray-800">Chọn chủ đề bạn quan tâm</h3>
                    <p className="max-w-md mx-auto text-gray-600">
                        Chọn một trong các chủ đề bên dưới hoặc nhập câu hỏi trực tiếp vào ô chat
                    </p>
                </motion.div>
            </div>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
                {actions.map((action, index) => (
                    <motion.button
                        key={index}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.1 }}
                        whileHover={{ scale: 1.02, y: -2 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => onActionClick(action.prompt)}
                        className={`${action.bgColor} hover:shadow-xl border border-gray-200/50 rounded-xl p-6 text-left transition-all duration-300 group relative overflow-hidden`}
                    >
                        {/* Background gradient effect */}
                        <div
                            className={`absolute inset-0 bg-gradient-to-r ${action.color} opacity-0 group-hover:opacity-5 transition-opacity duration-300`}
                        ></div>

                        <div className="relative flex items-start space-x-4">
                            <div
                                className={`w-12 h-12 bg-gradient-to-r ${action.color} rounded-lg flex items-center justify-center text-white shadow-lg group-hover:shadow-xl transition-all duration-300 group-hover:scale-110`}
                            >
                                {action.icon}
                            </div>
                            <div className="flex-1">
                                <h4 className="mb-2 font-semibold text-gray-900 transition-colors group-hover:text-gray-700">
                                    {action.title}
                                </h4>
                                <p className="text-sm leading-relaxed text-gray-600 transition-colors group-hover:text-gray-500">
                                    {action.description}
                                </p>
                            </div>
                        </div>

                        {/* Hover arrow indicator */}
                        <div className="absolute transition-opacity duration-300 opacity-0 top-4 right-4 group-hover:opacity-100">
                            <svg
                                className="w-5 h-5 text-gray-400"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    strokeLinecap="round"
                                    strokeLinejoin="round"
                                    strokeWidth={2}
                                    d="M17 8l4 4m0 0l-4 4m4-4H3"
                                />
                            </svg>
                        </div>
                    </motion.button>
                ))}
            </div>

            {/* Popular questions section */}
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6 }}
                className="mt-8 text-center"
            >
                <h4 className="mb-4 text-lg font-semibold text-gray-800">Câu hỏi phổ biến</h4>
                <div className="flex flex-wrap justify-center max-w-4xl gap-2 mx-auto">
                    {[
                        "Thủ tục đăng ký kết hôn",
                        "Quyền lợi người lao động",
                        "Hợp đồng mua bán nhà đất",
                        "Thành lập doanh nghiệp",
                        "Quyền thừa kế",
                        "Bảo hiểm xã hội",
                    ].map((question, index) => (
                        <motion.button
                            key={index}
                            initial={{ opacity: 0, scale: 0.9 }}
                            animate={{ opacity: 1, scale: 1 }}
                            transition={{ delay: 0.7 + index * 0.1 }}
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => onActionClick(`Tôi muốn hỏi về ${question}`)}
                            className="px-4 py-2 text-sm text-gray-700 transition-all duration-200 bg-white border border-gray-200 rounded-full shadow-sm hover:bg-blue-50 hover:text-blue-700 hover:border-blue-300 hover:shadow-md"
                        >
                            {question}
                        </motion.button>
                    ))}
                </div>
            </motion.div>
        </motion.div>
    );
};

export default QuickActions;

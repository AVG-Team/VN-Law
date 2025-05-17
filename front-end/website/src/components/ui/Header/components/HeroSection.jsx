import React, { memo } from "react";
import { motion } from "framer-motion";
import { ReactTyped } from "react-typed";
import BgHero from "~/assets/images/bg/bg-hero.png";

const FeatureCard = memo(({ icon, title, description, delay }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6, delay, ease: "easeOut" }}
        whileHover={{
            scale: 1.03,
            boxShadow: "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)",
        }}
        className="p-8 transition-all duration-300 bg-white shadow-lg rounded-2xl hover:bg-blue-50/50"
    >
        <div className="flex flex-col items-center">
            <motion.div whileHover={{ rotate: 360 }} transition={{ duration: 0.6, ease: "easeInOut" }}>
                <img src={icon} alt={title} className="w-12 h-12" />
            </motion.div>
            <motion.h4
                className="mt-6 text-xl font-semibold text-center text-gray-800"
                whileHover={{ color: "#1bddff" }}
            >
                {title}
            </motion.h4>
            <p className="mt-3 text-center text-gray-600">{description}</p>
        </div>
    </motion.div>
));

const HeroSection = memo(() => {
    const features = [
        {
            icon: "https://i.ibb.co/GcsvXxk/Product.png",
            title: "Tra cứu",
            description: "Tra cứu các văn bản pháp luật hiện hành của Việt Nam",
        },
        {
            icon: "https://i.ibb.co/Qn78BRJ/Ui-Design.png",
            title: "Văn bản quy phạm pháp luật",
            description: "Hệ thống cung cấp văn bản quy phạm pháp luật của Việt Nam",
        },
        {
            icon: "https://i.ibb.co/GcsvXxk/Product.png",
            title: "Chatbot",
            description: "Hệ thống chatbot hỗ trợ giải đáp các thắc mắc về pháp luật",
        },
    ];

    return (
        <div
            className="w-full bg-center bg-no-repeat bg-cover rounded-md"
            style={{ backgroundImage: `url(${BgHero})` }}
        >
            {/* Header */}
            <motion.header
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.8, ease: "easeOut" }}
                className="flex flex-col items-center justify-center gap-12 px-8 py-24 lg:flex-row lg:gap-20"
            >
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.6, ease: "easeOut" }}
                    className="w-full lg:w-[45%] text-center mt-12"
                >
                    <motion.p
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.2, ease: "easeOut" }}
                        className="text-2xl font-bold text-[#1bddff] mb-6"
                    >
                        Chào mọi người!
                    </motion.p>
                    <motion.h2
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.6, delay: 0.3, ease: "easeOut" }}
                        className="text-[35px] sm:text-[55px] font-semibold leading-[45px] sm:leading-[70px] h-52"
                    >
                        <span className="text-[#050505]">Legal Wise</span>{" "}
                        <ReactTyped
                            strings={["là hệ thống tri thức pháp luật Việt Nam"]}
                            typeSpeed={100}
                            backSpeed={100}
                            backDelay={5000}
                            loop
                            className="mb-2 text-5xl font-semibold text-blue-gray-950 white-space-nowrap"
                        />
                    </motion.h2>
                    <motion.p
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.4, ease: "easeOut" }}
                        className="max-w-2xl mx-auto mt-4 text-lg text-gray-600"
                    >
                        Đây là hệ thống hỗ trợ tra cứu giải đáp pháp luật Việt Nam
                    </motion.p>
                    <motion.button
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ duration: 0.5, delay: 0.5, ease: "easeOut" }}
                        whileHover={{
                            scale: 1.05,
                            boxShadow:
                                "0 20px 25px -5px rgba(32, 222, 255, 0.3), 0 10px 10px -5px rgba(32, 222, 255, 0.2)",
                        }}
                        whileTap={{ scale: 0.95 }}
                        className="px-10 py-4 mt-12 text-xl font-medium text-white rounded-full bg-[#20deff] shadow-lg hover:bg-[#2ba6b6] transition-all duration-300 ease-in-out"
                    >
                        Trải nghiệm
                    </motion.button>
                </motion.div>
            </motion.header>

            {/* Features Section */}
            <motion.section
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.6, ease: "easeOut" }}
                className="px-8 py-16 mt-24 bg-white rounded-t-3xl"
            >
                <motion.h2
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.5, delay: 0.2, ease: "easeOut" }}
                    className="mb-12 text-3xl font-bold text-center text-gray-800"
                >
                    Chức năng của chúng tôi
                </motion.h2>

                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 mt-8 w-full lg:w-[80%] mx-auto">
                    {features.map((feature, index) => (
                        <FeatureCard key={feature.title} {...feature} delay={0.1 * index} />
                    ))}
                </div>
            </motion.section>
        </div>
    );
});

HeroSection.displayName = "HeroSection";

export default HeroSection;

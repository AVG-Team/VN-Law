import React, { memo } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import SearchBar from "./SearchBar";

const HeroSection = memo(
    ({
        title = "Tìm kiếm thông tin pháp luật",
        description = "Tra cứu văn bản pháp luật, biểu mẫu và nhận tư vấn pháp lý từ chuyên gia",
        onSearch,
        className = "",
    }) => {
        return (
            <motion.section
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5 }}
                className={`relative py-20 md:py-32 overflow-hidden ${className}`}
            >
                {/* Background Pattern */}
                <div className="absolute inset-0 bg-gradient-to-br from-blue-50 to-white" />

                <div className="container relative px-4 mx-auto">
                    <motion.div
                        initial={{ y: 20, opacity: 0 }}
                        whileInView={{ y: 0, opacity: 1 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.5 }}
                        className="max-w-3xl mx-auto text-center"
                    >
                        <motion.h1
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: 0.1 }}
                            className="mb-6 text-4xl font-bold text-gray-900 md:text-5xl lg:text-6xl whitespace-nowrap"
                        >
                            {title}
                        </motion.h1>

                        <motion.p
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: 0.2 }}
                            className="mb-8 text-lg text-gray-600 md:text-xl"
                        >
                            {description}
                        </motion.p>

                        <motion.div
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: 0.3 }}
                        >
                            <SearchBar onSearch={onSearch} />
                        </motion.div>
                    </motion.div>
                </div>
            </motion.section>
        );
    },
);

HeroSection.propTypes = {
    title: PropTypes.string,
    description: PropTypes.string,
    onSearch: PropTypes.func,
    className: PropTypes.string,
};

HeroSection.displayName = "HeroSection";

export default HeroSection;

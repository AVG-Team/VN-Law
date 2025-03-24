import React, { memo } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import StatCard from "./StatCard";
import CountUp from "react-countup";

const defaultStats = [
    {
        icon: "📚",
        number: 10000,
        label: "Văn bản pháp luật",
    },
    {
        icon: "📝",
        number: 500,
        label: "Biểu mẫu pháp luật",
    },
    {
        icon: "👥",
        number: 50000,
        label: "Người dùng",
    },
    {
        icon: "📰",
        number: 1000,
        label: "Tin tức pháp luật",
    },
];

const StatsSection = memo(({ stats = defaultStats, className = "" }) => {
    return (
        <motion.section
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className={`py-16 md:py-24 ${className}`}
        >
            <div className="container px-4 mx-auto">
                <motion.div
                    initial={{ y: 20, opacity: 0 }}
                    whileInView={{ y: 0, opacity: 1 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.5 }}
                    className="grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-4"
                >
                    {stats.map((stat, index) => (
                        <StatCard
                            key={index}
                            icon={stat.icon}
                            number={stat.number}
                            label={stat.label}
                            delay={index * 0.1}
                        />
                    ))}
                </motion.div>
            </div>
        </motion.section>
    );
});

StatsSection.propTypes = {
    stats: PropTypes.arrayOf(
        PropTypes.shape({
            icon: PropTypes.string.isRequired,
            number: PropTypes.number.isRequired,
            label: PropTypes.string.isRequired,
        }),
    ),
    className: PropTypes.string,
};

StatsSection.displayName = "StatsSection";

export default StatsSection;

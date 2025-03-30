import React, { memo } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import CountUp from "react-countup";

const StatCard = memo(({ icon, number, label, delay = 0.2, duration = 2.5 }) => {
    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay }}
            className="flex flex-col items-center justify-center p-6 text-center transition-shadow duration-300 bg-white rounded-lg shadow-md hover:shadow-xl"
        >
            <motion.div className="mb-4 text-4xl" whileHover={{ scale: 1.1 }} transition={{ duration: 0.2 }}>
                {icon}
            </motion.div>
            <motion.div
                className="mb-2 text-3xl font-bold text-blue-600"
                whileHover={{ scale: 1.05 }}
                transition={{ duration: 0.2 }}
            >
                <CountUp end={number} duration={duration} separator="," />
            </motion.div>
            <p className="text-lg text-gray-600">{label}</p>
        </motion.div>
    );
});

StatCard.propTypes = {
    icon: PropTypes.string.isRequired,
    number: PropTypes.number.isRequired,
    label: PropTypes.string.isRequired,
    delay: PropTypes.number,
    duration: PropTypes.number,
};

StatCard.displayName = "StatCard";

export default StatCard;

import React from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";

const Skeleton = ({ className = "", variant = "rectangular", animation = "pulse" }) => {
    const baseClasses = "bg-gray-200";
    const animationClasses = {
        pulse: "animate-pulse",
        wave: "animate-shimmer",
        none: "",
    };

    const variantClasses = {
        rectangular: "rounded-lg",
        circular: "rounded-full",
        text: "rounded",
    };

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className={`${baseClasses} ${animationClasses[animation]} ${variantClasses[variant]} ${className}`}
        />
    );
};

Skeleton.propTypes = {
    className: PropTypes.string,
    variant: PropTypes.oneOf(["rectangular", "circular", "text"]),
    animation: PropTypes.oneOf(["pulse", "wave", "none"]),
};

export default Skeleton;

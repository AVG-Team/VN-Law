import React, { memo, useMemo, Suspense } from "react";
import PropTypes from "prop-types";
import Lottie from "lottie-react";
import { Button, Card, CardContent } from "@mui/material";
import { ArrowForward } from "@mui/icons-material";
import { motion } from "framer-motion";
import Skeleton from "../../../components/ui/Skeleton";

const NavigatorCardSkeleton = () => (
    <Card className="relative overflow-hidden border-none shadow-md !rounded-2xl bg-white">
        <CardContent className="p-6">
            <div className="flex flex-col h-full">
                <Skeleton className="w-24 h-6 mb-4" />
                <Skeleton className="w-48 h-8 mb-3" />
                <Skeleton className="w-full h-16 mb-6" />
                <Skeleton className="w-full h-32 mb-6" />
                <Skeleton className="w-32 h-6" />
            </div>
        </CardContent>
    </Card>
);

const NavigatorCard = memo(({ item, className = "", delay = 0.2, animationDuration = 0.3 }) => {
    // Memoize the animation data to prevent unnecessary re-renders
    const animationData = useMemo(() => item.animationData, [item.animationData]);

    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: animationDuration, delay }}
        >
            <Card
                className={`group relative overflow-hidden border-none shadow-md hover:shadow-xl transition-all duration-300 !rounded-2xl bg-white ${className}`}
            >
                <motion.div
                    className="absolute inset-0 bg-gradient-to-br from-blue-50/50 to-transparent"
                    initial={{ opacity: 0 }}
                    whileHover={{ opacity: 1 }}
                    transition={{ duration: 0.3 }}
                />

                <CardContent className="p-6">
                    <div className="flex flex-col h-full">
                        {/* Category Badge */}
                        <motion.div className="mb-4" whileHover={{ scale: 1.05 }} transition={{ duration: 0.2 }}>
                            <span className="px-3 py-1 text-sm font-medium text-blue-700 bg-blue-100 rounded-full">
                                {item.category}
                            </span>
                        </motion.div>

                        {/* Title */}
                        <motion.h3
                            className="mb-3 text-xl font-semibold text-gray-900"
                            whileHover={{ color: "#1e40af" }}
                            transition={{ duration: 0.2 }}
                        >
                            {item.title}
                        </motion.h3>

                        {/* Description */}
                        <p className="flex-grow mb-6 text-sm text-gray-600">{item.description}</p>

                        {/* Animation */}
                        <div className="relative mb-6">
                            <div className="absolute inset-0 z-10 bg-gradient-to-t from-white/80 to-transparent" />
                            <motion.div whileHover={{ scale: 1.05 }} transition={{ duration: 0.3 }}>
                                <Suspense fallback={<Skeleton className="w-full h-32" />}>
                                    <Lottie
                                        style={{
                                            width: "100%",
                                            height: 120,
                                            margin: "auto",
                                            filter: "drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1))",
                                        }}
                                        animationData={animationData}
                                        loop={true}
                                        autoplay={true}
                                    />
                                </Suspense>
                            </motion.div>
                        </div>

                        {/* Action Button */}
                        <motion.div
                            className="flex items-center justify-between mt-auto"
                            whileHover={{ x: 5 }}
                            transition={{ duration: 0.2 }}
                        >
                            <Button
                                className="!text-blue-700 hover:!text-blue-900 !font-medium !px-0 !py-0 !text-sm"
                                endIcon={<ArrowForward className="!text-sm" />}
                                href={item.link}
                            >
                                Tìm hiểu thêm
                            </Button>
                        </motion.div>
                    </div>
                </CardContent>
            </Card>
        </motion.div>
    );
});

NavigatorCard.propTypes = {
    item: PropTypes.shape({
        title: PropTypes.string.isRequired,
        description: PropTypes.string.isRequired,
        animationData: PropTypes.object.isRequired,
        link: PropTypes.string.isRequired,
        category: PropTypes.string.isRequired,
    }).isRequired,
    className: PropTypes.string,
    delay: PropTypes.number,
    animationDuration: PropTypes.number,
};

NavigatorCard.displayName = "NavigatorCard";

export { NavigatorCardSkeleton };
export default NavigatorCard;

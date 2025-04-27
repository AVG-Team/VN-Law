import React, { useEffect, useRef, useCallback } from "react";
import PropTypes from "prop-types";
import { motion, AnimatePresence } from "framer-motion";
import Skeleton from "./Skeleton";

const InfiniteScroll = ({
    children,
    onLoadMore,
    hasMore,
    isLoading,
    loadingComponent,
    threshold = 0.5,
    className = "",
}) => {
    const observerRef = useRef(null);
    const loadingRef = useRef(null);

    const handleObserver = useCallback(
        (entries) => {
            const [target] = entries;
            if (target.isIntersecting && hasMore && !isLoading) {
                onLoadMore();
            }
        },
        [hasMore, isLoading, onLoadMore],
    );

    useEffect(() => {
        const options = {
            root: null,
            rootMargin: "20px",
            threshold: threshold,
        };

        observerRef.current = new IntersectionObserver(handleObserver, options);

        if (loadingRef.current) {
            observerRef.current.observe(loadingRef.current);
        }

        return () => {
            if (observerRef.current) {
                observerRef.current.disconnect();
            }
        };
    }, [handleObserver, threshold]);

    const defaultLoadingComponent = (
        <div className="flex items-center justify-center py-4">
            <Skeleton className="w-8 h-8 rounded-full" />
            <span className="ml-2 text-gray-500">Đang tải...</span>
        </div>
    );

    return (
        <div className={className}>
            {children}
            <AnimatePresence>
                {hasMore && (
                    <motion.div
                        ref={loadingRef}
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="mt-4"
                    >
                        {isLoading ? loadingComponent || defaultLoadingComponent : null}
                    </motion.div>
                )}
            </AnimatePresence>
        </div>
    );
};

InfiniteScroll.propTypes = {
    children: PropTypes.node.isRequired,
    onLoadMore: PropTypes.func.isRequired,
    hasMore: PropTypes.bool.isRequired,
    isLoading: PropTypes.bool.isRequired,
    loadingComponent: PropTypes.node,
    threshold: PropTypes.number,
    className: PropTypes.string,
};

export default InfiniteScroll;

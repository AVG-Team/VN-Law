import React, { memo, useState, useCallback } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import { Card, CardContent, CardMedia, Typography, Box } from "@mui/material";
import { CalendarToday } from "@mui/icons-material";
import InfiniteScroll from "~/components/ui/InfiniteScroll";
import ErrorBoundary from "~/components/error/ErrorBoundary";
import Skeleton from "~/components/ui/Skeleton";

const NewsCard = memo(({ news, index }) => (
    <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5, delay: index * 0.1 }}
    >
        <Card className="h-full overflow-hidden transition-all duration-300 border-none shadow-md hover:shadow-xl">
            <CardMedia component="img" height="200" image={news.image} alt={news.title} className="object-cover" />
            <CardContent className="p-4">
                <Box className="flex items-center gap-2 mb-2">
                    <CalendarToday className="text-sm text-gray-500" />
                    <Typography variant="caption" className="text-gray-500">
                        {news.date}
                    </Typography>
                </Box>
                <Typography variant="h6" className="mb-2 line-clamp-2">
                    {news.title}
                </Typography>
                <Typography variant="body2" className="text-gray-600 line-clamp-3">
                    {news.description}
                </Typography>
            </CardContent>
        </Card>
    </motion.div>
));

const NewsSkeleton = () => (
    <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
        {[...Array(6)].map((_, index) => (
            <Card key={index} className="h-full overflow-hidden border-none shadow-md">
                <Skeleton className="w-full h-48" />
                <CardContent className="p-4">
                    <Skeleton className="w-24 h-4 mb-2" />
                    <Skeleton className="w-full h-6 mb-2" />
                    <Skeleton className="w-full h-16" />
                </CardContent>
            </Card>
        ))}
    </div>
);

const NewsSection = memo(
    ({
        title,
        description,
        featuredNews,
        initialNews,
        onLoadMore,
        hasMore,
        isLoading,
        className = "",
        delay = 0.2,
    }) => {
        const [news, setNews] = useState(initialNews || []);

        const handleLoadMore = useCallback(async () => {
            if (onLoadMore) {
                const newNews = await onLoadMore();
                setNews((prev) => [...prev, ...newNews]);
            }
        }, [onLoadMore]);

        return (
            <ErrorBoundary>
                <motion.section
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.5, delay }}
                    className={`py-16 ${className}`}
                >
                    <div className="container px-4 mx-auto">
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: delay + 0.1 }}
                            className="mb-12 text-center"
                        >
                            <h2 className="mb-4 text-3xl font-bold">{title}</h2>
                            <p className="max-w-2xl mx-auto text-gray-600">{description}</p>
                        </motion.div>

                        <InfiniteScroll
                            onLoadMore={handleLoadMore}
                            hasMore={hasMore}
                            isLoading={isLoading}
                            loadingComponent={<NewsSkeleton />}
                            threshold={0.5}
                        >
                            <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
                                {news.slice(0, 6).map((item, index) => (
                                    <NewsCard key={item.id} news={item} index={index} />
                                ))}
                            </div>
                        </InfiniteScroll>
                    </div>
                </motion.section>
            </ErrorBoundary>
        );
    },
);

NewsSection.propTypes = {
    title: PropTypes.string,
    description: PropTypes.string,
    featuredNews: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.string.isRequired,
            title: PropTypes.string.isRequired,
            description: PropTypes.string.isRequired,
            image: PropTypes.string.isRequired,
            date: PropTypes.string.isRequired,
        }),
    ),
    initialNews: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.string.isRequired,
            title: PropTypes.string.isRequired,
            description: PropTypes.string.isRequired,
            image: PropTypes.string.isRequired,
            date: PropTypes.string.isRequired,
        }),
    ),
    onLoadMore: PropTypes.func,
    hasMore: PropTypes.bool,
    isLoading: PropTypes.bool,
    className: PropTypes.string,
    delay: PropTypes.number,
};

NewsSection.defaultProps = {
    title: "Tin tức pháp luật",
    description: "Cập nhật những tin tức mới nhất về pháp luật và chính sách",
    featuredNews: [],
    initialNews: [],
    hasMore: false,
    isLoading: false,
    delay: 0.2,
};

NewsSection.displayName = "NewsSection";

export default NewsSection;

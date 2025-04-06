import React from "react";
import HeroSection from "./components/HeroSection";
import StatsSection from "./components/StatsSection";
import FeaturesSection from "./components/FeaturesSection";
import NewsSection from "./components/NewsSection";
import NewsletterSection from "./components/NewsletterSection";
import { NavigatorCardData } from "../../mock/Home.data";
import { featuredNews, regularNews } from "../../mock/News.data";

const Home = () => {
    const handleSearch = (query) => {
        console.log("Searching for:", query);
        // Implement search functionality
    };

    const handleLoadMore = async () => {
        // Simulate loading more news
        await new Promise((resolve) => setTimeout(resolve, 1000));
        return regularNews;
    };

    return (
        <main className="px-4 md:px-20">
            <HeroSection onSearch={handleSearch} />
            <StatsSection />
            <FeaturesSection items={NavigatorCardData} />
            <NewsSection
                featuredNews={featuredNews}
                initialNews={regularNews}
                onLoadMore={handleLoadMore}
                hasMore={true}
                isLoading={false}
            />
            <NewsletterSection />
        </main>
    );
};

export default Home;

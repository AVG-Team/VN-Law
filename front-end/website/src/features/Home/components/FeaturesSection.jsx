import React from "react";
import NavigatorCard from "./NavigatorCard";
import { NavigatorCardData } from "../../../mock/Home.data";

export default function FeaturesSection() {
    return (
        <div className="mb-24">
            <h2 className="mb-12 text-3xl font-bold text-center text-transparent md:text-4xl bg-clip-text bg-gradient-to-r from-blue-900 to-blue-600">
                Tính năng nổi bật
            </h2>
            <div className="grid grid-cols-1 gap-8 md:grid-cols-3">
                {NavigatorCardData.map((item) => (
                    <NavigatorCard key={item.index} item={item} />
                ))}
            </div>
        </div>
    );
}

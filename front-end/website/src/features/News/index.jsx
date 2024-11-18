import React from "react";
import HotNews from "./components/HotNews";
import ClassificationNews from "./components/ClassificationNews";
import ListNews from "./components/ListNews";

export default function News() {
    return (
        <main>
            <div className="">
                <HotNews />
                <ClassificationNews />
                <ListNews />
            </div>
        </main>
    );
}

import React from "react";
import Carousel from "../../../components/Carousel";

export default function News() {
    const items = [
        { id: 1, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 1" },
        { id: 2, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 2" },
        { id: 3, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 3" },
        { id: 4, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 4" },
        { id: 5, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 5" },
        { id: 6, imagePath: "https://i.ibb.co/7zvJYkP/Rectangle-1.png", title: "Tin tức 6" },
    ];
    return (
        <div className="mt-10 mb-5">
            <div className="flex-row items-center justify-center">
                <div className="tracking-normal text-center text-blue-gray-900">
                    <h1 className="text-2xl font-extrabold">Tin tức</h1>
                    <p>Đọc tin tức mới nhất về pháp luật</p>
                </div>
                <div className="">
                    <Carousel items={items} />
                </div>
            </div>
        </div>
    );
}

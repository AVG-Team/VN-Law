import { faClock } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

export default function HotNews() {
    return (
        <div className="px-10 py-8 bg-blue-950">
            <div className="grid items-center grid-cols-1 gap-6 lg:grid-cols-2">
                {/* Image Section */}
                <div className="flex justify-center">
                    <img
                        src="https://via.placeholder.com/300"
                        alt="hot-news"
                        className="object-cover w-4/5 h-auto rounded-lg shadow-lg"
                    />
                </div>

                {/* Content Section */}
                <div className="flex flex-col justify-center space-y-4">
                    {/* Category and Date */}
                    <div className="flex items-center space-x-4">
                        <span className="px-6 py-2 text-lg font-bold text-white bg-green-500 rounded-lg">Tech</span>
                        <span className="flex items-center text-base font-medium text-white">
                            <FontAwesomeIcon icon={faClock} className="mr-2" />
                            20-11-2024
                        </span>
                    </div>

                    {/* Title */}
                    <h2 className="text-3xl font-bold leading-tight text-white">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec odio
                    </h2>

                    {/* Description */}
                    <p className="text-base font-medium leading-relaxed text-white">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec nec odio Lorem ipsum dolor sit
                        amet, consectetur adipiscing elit. Donec nec odio
                    </p>

                    {/* Button */}
                    <button className="px-6 py-3 font-semibold text-white bg-green-500 rounded-lg hover:bg-green-600">
                        Xem thêm
                    </button>
                </div>
            </div>
            <div className="grid grid-cols-1 gap-6 mt-10 sm:grid-cols-2 lg:grid-cols-4">
                {/* Card 1 */}
                <div className="overflow-hidden bg-white rounded-lg shadow-md">
                    <img src="https://via.placeholder.com/300" alt="Tech news" className="object-cover w-full h-40" />
                    <div className="p-4">
                        <span className="inline-block px-3 py-1 text-sm font-semibold text-white bg-blue-500 rounded-full">
                            Tech
                        </span>
                        <h3 className="mt-3 text-lg font-bold text-gray-800">
                            The FAA will test drone detecting technologies in airports this year
                        </h3>
                        <div className="flex items-center mt-2 text-sm text-gray-500">
                            <FontAwesomeIcon icon={faClock} className="mr-2" />
                            08.22.2020
                        </div>
                    </div>
                </div>

                {/* Card 2 */}
                <div className="overflow-hidden bg-white rounded-lg shadow-md">
                    <img src="https://via.placeholder.com/300" alt="Food news" className="object-cover w-full h-40" />
                    <div className="p-4">
                        <span className="inline-block px-3 py-1 text-sm font-semibold text-white bg-orange-500 rounded-full">
                            Food
                        </span>
                        <h3 className="mt-3 text-lg font-bold text-gray-800">
                            Rocket Lab will resume launches no sooner than August 27th
                        </h3>
                        <div className="flex items-center mt-2 text-sm text-gray-500">
                            <FontAwesomeIcon icon={faClock} className="mr-2" />
                            08.22.2020
                        </div>
                    </div>
                </div>

                {/* Card 3 */}
                <div className="overflow-hidden bg-white rounded-lg shadow-md">
                    <img src="https://via.placeholder.com/300" alt="Tech news" className="object-cover w-full h-40" />
                    <div className="p-4">
                        <span className="inline-block px-3 py-1 text-sm font-semibold text-white bg-blue-500 rounded-full">
                            Tech
                        </span>
                        <h3 className="mt-3 text-lg font-bold text-gray-800">
                            Google Drive flaw may let attackers fool you into installing malware
                        </h3>
                        <div className="flex items-center mt-2 text-sm text-gray-500">
                            <FontAwesomeIcon icon={faClock} className="mr-2" />
                            08.22.2020
                        </div>
                    </div>
                </div>

                {/* Card 4 */}
                <div className="overflow-hidden bg-white rounded-lg shadow-md">
                    <img src="https://via.placeholder.com/300" alt="Food news" className="object-cover w-full h-40" />
                    <div className="p-4">
                        <span className="inline-block px-3 py-1 text-sm font-semibold text-white bg-orange-500 rounded-full">
                            Food
                        </span>
                        <h3 className="mt-3 text-lg font-bold text-gray-800">
                            TikTok will sue the US over threatened ban
                        </h3>
                        <div className="flex items-center mt-2 text-sm text-gray-500">
                            <FontAwesomeIcon icon={faClock} className="mr-2" />
                            08.22.2020
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

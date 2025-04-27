import { faFacebook } from "@fortawesome/free-brands-svg-icons";
import { faClock } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

export default function ClassificationNews() {
    return (
        <div className="p-10 bg-gray-50">
            {/* Grid Container */}
            <div className="grid grid-cols-1 gap-6 md:grid-cols-4">
                {/* Trending News */}
                <div className="col-span-1">
                    <h2 className="mb-4 text-xl font-bold text-blue-900">Trending News</h2>
                    <div className="space-y-4">
                        {/* News Item */}
                        <div className="flex space-x-4">
                            <img
                                src="https://via.placeholder.com/100"
                                alt="Trending News"
                                className="object-cover w-20 h-20 rounded"
                            />
                            <div>
                                <p className="flex items-center text-sm text-gray-500">
                                    <FontAwesomeIcon icon={faClock} className="mr-2" /> December 26, 2018
                                </p>
                                <h3 className="text-sm font-bold text-gray-800">The FAA will test drone</h3>
                            </div>
                        </div>
                        {/* Add more items similarly */}
                    </div>
                </div>

                {/* Latest News */}
                <div className="col-span-1">
                    <h2 className="mb-4 text-xl font-bold text-blue-900">Latest News</h2>
                    <div className="space-y-4">
                        {/* News Item */}
                        <div className="flex items-center space-x-4">
                            <img
                                src="https://via.placeholder.com/40"
                                alt="Latest News"
                                className="object-cover w-10 h-10 rounded"
                            />
                            <div>
                                <p className="flex items-center text-sm text-gray-500">
                                    <FontAwesomeIcon icon={faClock} className="mr-2" /> 08.22.2020
                                </p>
                                <h3 className="text-sm font-bold text-gray-800">Online registration...</h3>
                            </div>
                        </div>
                        {/* Add more items similarly */}
                    </div>
                </div>

                {/* What's New */}
                <div className="col-span-1">
                    <h2 className="mb-4 text-xl font-bold text-blue-900">What's new</h2>
                    <div className="p-4 bg-white rounded-lg shadow-lg">
                        <img
                            src="https://via.placeholder.com/300"
                            alt="What's new"
                            className="object-cover w-full h-40 rounded"
                        />
                        <div className="mt-4">
                            <span className="px-3 py-1 text-xs font-semibold text-white bg-blue-500 rounded">Tech</span>
                            <p className="flex items-center mt-2 text-sm text-gray-500">
                                <FontAwesomeIcon icon={faClock} className="mr-2" /> 08.22.2020
                            </p>
                            <h3 className="mt-2 text-lg font-bold text-gray-800">
                                Uttarakhand’s Hemkund Sahib yatra to start...
                            </h3>
                            <p className="mt-2 text-sm text-gray-600">
                                Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
                                incididunt ut labore et...
                            </p>
                        </div>
                    </div>
                </div>

                {/* Join With Us */}
                <div className="col-span-1">
                    <h2 className="mb-4 text-xl font-bold text-blue-900">Join With Us</h2>
                    <div className="space-y-4">
                        {/* Social Media Link */}
                        <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-2">
                                <FontAwesomeIcon icon={faFacebook} className="text-lg text-blue-700" />
                                <span className="text-sm font-semibold text-gray-700">12,300 Like</span>
                            </div>
                            <button className="text-sm font-semibold text-blue-500">+</button>
                        </div>
                        {/* Repeat for other social media */}
                    </div>
                    <div className="mt-6">
                        <img
                            src="https://via.placeholder.com/300"
                            alt="Banner"
                            className="object-cover w-full h-40 rounded-lg"
                        />
                        <p className="mt-2 text-sm text-center text-gray-500">Place your Banner</p>
                    </div>
                </div>
            </div>
        </div>
    );
}

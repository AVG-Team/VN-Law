import React from "react";

export default function ListNews() {
    return (
        <div className="p-10 bg-gray-50">
            <div className="grid grid-cols-1 gap-6 lg:grid-cols-4">
                <div className="grid grid-cols-1 gap-6 lg:col-span-3 md:grid-cols-3">
                    <div className="relative">
                        <img
                            src="https://via.placeholder.com/600"
                            alt="Featured News"
                            className="object-cover w-full rounded-lg h-72"
                        />
                        <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                            <span className="text-xs font-bold text-blue-500 uppercase">Fashion</span>
                            <p className="mt-1 text-sm text-gray-600">08.22.2020</p>
                            <h3 className="text-lg font-bold text-gray-800">
                                A Comparison of the Sony FE 85mm f/1.4 GM and Sigma
                            </h3>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 gap-6">
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    Rocket Lab will resume launches no sooner than
                                </h3>
                            </div>
                        </div>
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    P2P Exchanges in Africa Pivot: Nigeria and Kenya the
                                </h3>
                            </div>
                        </div>
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    The Bitcoin Network Now 7 Plants Worth of Power
                                </h3>
                            </div>
                        </div>
                    </div>
                    <div className="grid grid-cols-1 gap-6">
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    Rocket Lab will resume launches no sooner than
                                </h3>
                            </div>
                        </div>
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    P2P Exchanges in Africa Pivot: Nigeria and Kenya the
                                </h3>
                            </div>
                        </div>
                        <div className="relative">
                            <img
                                src="https://via.placeholder.com/400"
                                alt="News"
                                className="object-cover w-full rounded-lg h-36"
                            />
                            <div className="absolute px-3 py-2 bg-white rounded-lg bottom-4 left-4 bg-opacity-90">
                                <p className="text-sm text-gray-600">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">
                                    The Bitcoin Network Now 7 Plants Worth of Power
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <h2 className="mb-4 text-xl font-bold text-gray-900">Trending News</h2>
                    <div className="space-y-4">
                        <div className="flex items-center space-x-4">
                            <img
                                src="https://via.placeholder.com/60"
                                alt="Trending News"
                                className="object-cover w-16 h-16 rounded-lg"
                            />
                            <div>
                                <p className="text-sm text-gray-500">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">Important to rate more liquidity</h3>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <img
                                src="https://via.placeholder.com/60"
                                alt="Trending News"
                                className="object-cover w-16 h-16 rounded-lg"
                            />
                            <div>
                                <p className="text-sm text-gray-500">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">Sounds like John got the Josh</h3>
                            </div>
                        </div>
                        <div className="flex items-center space-x-4">
                            <img
                                src="https://via.placeholder.com/60"
                                alt="Trending News"
                                className="object-cover w-16 h-16 rounded-lg"
                            />
                            <div>
                                <p className="text-sm text-gray-500">08.22.2020</p>
                                <h3 className="text-sm font-bold text-gray-800">Grayscale's and Bitcoin Trusts</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

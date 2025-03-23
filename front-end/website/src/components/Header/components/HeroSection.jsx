import React from "react";
import BgHero from "../../../assets/images/bg/bg-hero.png";
import { ReactTyped } from "react-typed";
const HeroSection = () => {
    return (
        <div
            className="w-full bg-center bg-no-repeat bg-cover rounded-md"
            style={{
                backgroundImage: `url(${BgHero})`,
            }}
        >
            {/* Header */}
            <header className="flex flex-col items-center justify-center gap-8 px-8 py-20 lg:flex-row lg:gap-16">
                <div className="w-full lg:w-[45%] text-center mt-12">
                    <p className="text-2xl font-bold text-[#1bddff]">Chào mọi người!</p>
                    <h2 className="text-[35px] sm:text-[55px] font-semibold leading-[45px] sm:leading-[70px] h-36">
                        <span className="text-[#050505]">Legal Wise</span>{" "}
                        <ReactTyped
                            strings={["là hệ thống tri thức pháp luật Việt Nam"]}
                            typeSpeed={100}
                            backSpeed={100}
                            backDelay={5000}
                            loop
                            className="mb-2 text-5xl font-semibold text-blue-gray-950"
                        />
                    </h2>
                    <p className="mt-2 text-lg text-gray-600">
                        Đây là hệ thống hỗ trợ tra cứu giải đáp pháp luật Việt Nam
                    </p>
                    <button className="px-8 py-4 rounded-full bg-[#20deff] text-white mt-10 text-xl font-medium shadow-md hover:bg-[#2ba6b6] hover:scale-105 transition duration-300 ease-in-out">
                        Trải nghiệm
                    </button>
                </div>
            </header>

            {/* Chức năng */}
            <section className="px-8 py-12 mt-24 bg-white rounded-t-3xl">
                <h1 className="text-2xl font-semibold text-center">Chức năng của chúng tôi</h1>

                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 mt-8 w-full lg:w-[80%] mx-auto">
                    <div className="p-6 transition duration-300 bg-gray-100 shadow-md rounded-xl hover:shadow-lg">
                        <img src="https://i.ibb.co/GcsvXxk/Product.png" alt="Vector" className="w-[40px] mx-auto" />
                        <h4 className="mt-4 text-xl font-medium text-center">Tra cứu</h4>
                        <p className="mt-2 text-center text-gray-600">
                            Tra cứu các văn bản pháp luật hiện hành của Việt Nam
                        </p>
                    </div>
                    <div className="p-6 transition duration-300 bg-gray-100 shadow-md rounded-xl hover:shadow-lg">
                        <img src="https://i.ibb.co/Qn78BRJ/Ui-Design.png" alt="Vector" className="w-[40px] mx-auto" />
                        <h4 className="mt-4 text-xl font-medium text-center">Văn bản quy phạm pháp luật</h4>
                        <p className="mt-2 text-center text-gray-600">
                            Hệ thống cung cấp văn bản quy phạm pháp luật của Việt Nam
                        </p>
                    </div>
                    <div className="p-6 transition duration-300 bg-gray-100 shadow-md rounded-xl hover:shadow-lg">
                        <img src="https://i.ibb.co/GcsvXxk/Product.png" alt="Vector" className="w-[40px] mx-auto" />
                        <h4 className="mt-4 text-xl font-medium text-center">Chatbot</h4>
                        <p className="mt-2 text-center text-gray-600">
                            Hệ thống chatbot hỗ trợ giải đáp các thắc mắc về pháp luật
                        </p>
                    </div>
                </div>
            </section>
        </div>
    );
};

export default HeroSection;

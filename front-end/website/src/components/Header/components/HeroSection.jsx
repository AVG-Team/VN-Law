import React from "react";
import lawHero from "../../../assets/images/lottie/lawHero.json";
import Lottie from "lottie-react";
const HeroSection = () => {
    return (
        <div className="w-full bg-[#fff] rounded-md relative px-10 py-12">
            {/* header */}
            <header className="flex flex-col items-center justify-between gap-12 px-8 lg:flex-row lg:gap-0">
                <div className="w-[100px] h-[100px] bg-[#008DDA] blur-[90px] absolute bottom-[80px] right-[80px]"></div>
                <div className="w-full lg:w-[45%]">
                    <p>Chào mọi người!</p>
                    <h2 className="text-[35px] sm:text-[55px] font-semibold leading-[45px] sm:leading-[70px]">
                        <span className="text-[#41C9E2]">VN Law</span> là nơi bạn tìm kiếm thông tin pháp luật
                    </h2>
                    <p className="mt-2 text-[1rem]">Đây là hệ thống hỗ trợ tra cứu giải đáp pháp luật Việt Nam</p>
                </div>

                <div className="w-full lg:w-[55%]">
                    <Lottie style={{ width: 900, height: 300, margin: "auto" }} animationData={lawHero} />
                    {/* <img src="https://i.ibb.co/syHFhNy/image.png" alt="image" className="" /> */}
                </div>
            </header>

            <section className="px-8 pb-[30px]">
                <h1 className="text-[1.3rem] font-semibold">Chức năng của chúng tôi</h1>

                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[20px] mt-10 w-[70%]">
                    <div>
                        <img src="https://i.ibb.co/GcsvXxk/Product.png" alt="Vector" className="w-[30px]" />
                        <h4 className="text-[1.1rem] mt-3">Tra cứu</h4>
                        <p className="text-[0.9rem] text-gray-500 mt-1">
                            Tra cứu các văn bản pháp luật hiện hành của Việt Nam
                        </p>
                    </div>
                    <div>
                        <img src="https://i.ibb.co/Qn78BRJ/Ui-Design.png" alt="Vector" className="w-[30px]" />
                        <h4 className="text-[1.1rem] mt-3">Văn bản quy phạm pháp luật</h4>
                        <p className="text-[0.9rem] text-gray-500 mt-1">
                            Hệ thống cung cấp văn bản quy phạm pháp luật của Việt Nam
                        </p>
                    </div>
                    <div>
                        <img src="https://i.ibb.co/GcsvXxk/Product.png" alt="Vector" className="w-[30px]" />
                        <h4 className="text-[1.1rem] mt-3">Chatbot</h4>
                        <p className="text-[0.9rem] text-gray-500 mt-1">
                            Hệ thống chatbot hỗ trợ giải đáp các thắc mắc về pháp luật
                        </p>
                    </div>
                </div>
            </section>

            {/* right blur shadow */}
        </div>
    );
};

export default HeroSection;

import React from "react";
import { MdOutlineMail } from "react-icons/md";

const NewsletterForm = () => {
    return (
        <section className="w-full rounded-xl py-[20px] sm:py-[40px] px-[40px] sm:px-[80px] bg-gradient-to-br from-[#008DDA] to-[#ACE2E1] relative overflow-hidden">
            <div className="w-full sm:w-[60%]">
                <div className="w-full sm:w-[60%]">
                    <h1 className="text-[2rem] sm:text-[2.8rem] text-[#fff] font-[400] leading-[45px]">
                        Đăng ký nhận thông báo từ chúng tôi
                    </h1>
                    <p className="text-[0.9rem] text-[#fff] mt-5">Thông báo được gửi khi có thông tin mới✌️</p>
                </div>

                <div className="relative mt-12 mb-6">
                    <input className="w-full py-3 pl-12 pr-4 outline-none" placeholder="Email Address" />
                    <MdOutlineMail className="p-1.5 bg-[#F8F8F8] text-[#6C777C] text-[2rem] absolute top-[50%] left-2 transform translate-y-[-50%]" />

                    <button className="absolute bottom-[-20px] right-[-20px] bg-[#008DDA] hover:bg-[#41C9E2] text-white py-3 px-8">
                        subscribe
                    </button>
                </div>
            </div>

            <MdOutlineMail className="text-[30rem] absolute top-[-100px] right-[-100px] text-white opacity-10 rotate-[-30deg]" />
        </section>
    );
};

export default NewsletterForm;

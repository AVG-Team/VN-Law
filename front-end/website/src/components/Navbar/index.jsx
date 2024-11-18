import React, { useState } from "react";
import Logo from "../../assets/images/logo/logo2.png";
import { IoIosArrowDown, IoIosArrowUp } from "react-icons/io";
import { TbLogout2 } from "react-icons/tb";
import { CiMenuFries } from "react-icons/ci";
import { MdOutlineKeyboardArrowRight } from "react-icons/md";
import { FiUser } from "react-icons/fi";
import { IoSettingsOutline } from "react-icons/io5";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faUser } from "@fortawesome/free-solid-svg-icons";
import { useNavigate } from "react-router-dom";

export default function Navbar() {
    const [accountMenuOpen, setAccountMenuOpen] = useState(false);
    const [isProductHover, setIsProductHover] = useState(false);
    const [mobileSidebarOpen, setMobileSidebarOpen] = useState(false);
    const [productMobileMegaMenu, setProductMobileMegaMenu] = useState(false);
    const [megaMenuSubItem, setMegaMenuSubItem] = useState("");

    const navigate = useNavigate();

    return (
        <nav className="relative flex items-center justify-between w-full px-20 py-4 bg-white ">
            <img src={Logo} alt="logo" className="w-[170px] " onClick={() => navigate("/")} />
            <div className="items-center gap-[20px] text-[1rem] text-[#424242] font-bold lg:flex hidden">
                <button
                    className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]"
                    onClick={() => navigate("/phap-dien")}
                >
                    Tra Cứu
                </button>
                <button
                    onClick={() => navigate("/van-ban-quy-pham-phap-luat")}
                    className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]"
                >
                    Văn Bản
                </button>

                <button
                    className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]"
                    onClick={() => navigate("/chatbot")}
                >
                    Chatbot
                </button>
                <button
                    className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]"
                    onClick={() => navigate("/tin-tuc")}
                >
                    Tin Tức
                </button>
                <button
                    className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]"
                    onClick={() => navigate("/dien-dan")}
                >
                    Diễn đàn
                </button>
                <button className="flex items-center gap-[5px] cursor-pointer hover:text-[#3B9DF8]">Khác</button>
            </div>

            <div className="flex items-center gap-[15px]">
                <div
                    className="flex items-center gap-[10px] cursor-pointer relative"
                    role="button"
                    tabIndex={0}
                    onClick={() => setAccountMenuOpen(!accountMenuOpen)}
                    onKeyDown={(e) => {
                        if (e.key === "Enter" || e.key === " ") {
                            setAccountMenuOpen(!accountMenuOpen);
                        }
                    }}
                >
                    <div className="relative">
                        <FontAwesomeIcon
                            icon={faUser}
                            className="w-[20px] h-[20px] rounded-full object-cover"
                        ></FontAwesomeIcon>
                        <div className="w-[10px] h-[10px] rounded-full bg-green-500 absolute bottom-[0px] right-0 border-2 border-white"></div>
                    </div>

                    <h1 className="text-[1rem] font-[400] text-gray-600 sm:block hidden">Anonymus</h1>

                    <div
                        className={`${
                            accountMenuOpen ? "translate-y-0 opacity-100 z-[3]" : "translate-y-[10px] opacity-0 z-[-1]"
                        } bg-blue-100 w-max rounded-md boxShadow absolute top-[45px] right-0 p-[10px] flex flex-col transition-all duration-300 gap-[5px]`}
                    >
                        <button
                            onClick={() => navigate("/thong-tin-ca-nhan")}
                            className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50"
                        >
                            <FiUser />
                            View Profile
                        </button>
                        <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50">
                            <IoSettingsOutline />
                            Settings
                        </p>
                        <div className="mt-1 border-t border-gray-300 pt-[5px]">
                            <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-red-500 hover:bg-red-50">
                                <TbLogout2 />
                                Logout
                            </p>
                        </div>
                    </div>

                    <IoIosArrowUp
                        className={`${
                            accountMenuOpen ? "rotate-0" : "rotate-[180deg]"
                        } transition-all duration-300 text-gray-600 sm:block hidden`}
                    />
                </div>

                <CiMenuFries
                    onClick={() => setMobileSidebarOpen(!mobileSidebarOpen)}
                    className="text-[1.8rem] text-[#424242]c cursor-pointer lg:hidden flex"
                />
            </div>
        </nav>
    );
}

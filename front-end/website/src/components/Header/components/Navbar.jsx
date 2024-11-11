import React, { useState } from "react";
import Logo from "../../../assets/images/logo/logo2.png";
import { FaFontAwesome, FaGlassMartini, FaSearch, FaTasks, FaUser } from "react-icons/fa";
import { IoIosArrowDown, IoIosArrowUp } from "react-icons/io";
import { TbLogout2, TbUsersGroup } from "react-icons/tb";
import { CiMenuFries } from "react-icons/ci";
import { MdLaptopMac, MdOutlineArrowRightAlt, MdOutlineKeyboardArrowRight } from "react-icons/md";
import { BsBuildings, BsCalendar2Date } from "react-icons/bs";
import { AiOutlineFire } from "react-icons/ai";
import { BiSupport } from "react-icons/bi";
import { FiUser } from "react-icons/fi";
import { IoSettingsOutline } from "react-icons/io5";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faBars,
    faBook,
    faComment,
    faComments,
    faMagnifyingGlass,
    faUser,
    faUserAlt,
} from "@fortawesome/free-solid-svg-icons";
import { useNavigate } from "react-router-dom";

export default function Navbar() {
    const [accountMenuOpen, setAccountMenuOpen] = useState(false);
    const [isProductHover, setIsProductHover] = useState(false);
    const [mobileSidebarOpen, setMobileSidebarOpen] = useState(false);
    const [productMobileMegaMenu, setProductMobileMegaMenu] = useState(false);
    const [megaMenuSubItem, setMegaMenuSubItem] = useState("");

    const navigate = useNavigate();

    return (
        <nav className="relative flex items-center justify-between w-full px-20 ">
            <img src={Logo} alt="logo" className="w-[150px] " onClick={() => navigate("/")} />
            <ul className="items-center gap-[20px] text-[1rem] text-[#424242] lg:flex hidden">
                <li
                    className={`${
                        isProductHover ? "text-[#3B9DF8]" : "text-gray-600"
                    } flex items-center gap-[5px] cursor-pointer`}
                    onMouseEnter={() => setIsProductHover(true)}
                    onMouseLeave={() => setIsProductHover(false)}
                    onClick={() => navigate("/phap-dien")}
                >
                    <FontAwesomeIcon icon={faMagnifyingGlass} className="text-[1.1rem]" />
                    Tra Cứu
                    {/* <IoIosArrowUp
                        className={`${isProductHover ? "rotate-0" : "rotate-[-180deg]"} transition-all duration-300`}
                    /> */}
                    {/* mega menu */}
                    {/* <div
                        className={`${
                            isProductHover ? "translate-y-0 opacity-100 z-30" : "translate-y-[20px] opacity-0 z-[-1]"
                        } bg-white rounded-md w-full absolute top-[40px] left-0 p-[30px] transition-all duration-300 boxShadow flex flex-wrap gap-[30px]`}
                    >
                        <div className="grid grid-cols-2 gap-[30px]">
                            <div className="flex flex-col gap-[20px]">
                                <h3 className="text-[1.2rem] text-gray-500 font-[500]">More Products</h3>

                                <div className="flex float-start gap-[10px] group">
                                    <img
                                        src="https://i.ibb.co/LQBDJGD/icon-logo-container.png"
                                        alt="image"
                                        className="w-[30px] h-[30px]"
                                    />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">Demo App</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>

                                        <button className="text-[#FF5E5E] mt-2 flex items-center gap-[4px] text-[0.9rem]">
                                            Call to action
                                            <MdOutlineArrowRightAlt className="text-[1.4rem] group-hover:ml-[5px] transition-all duration-300" />
                                        </button>
                                    </div>
                                </div>
                                <div className="flex float-start gap-[10px] group">
                                    <img
                                        src="https://i.ibb.co/Y8cRWRj/icon-logo-container-1.png"
                                        alt="image"
                                        className="w-[30px] h-[30px]"
                                    />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">CRM</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>

                                        <button className="text-[#FE9239] mt-2 flex items-center gap-[4px] text-[0.9rem]">
                                            Call to action
                                            <MdOutlineArrowRightAlt className="text-[1.4rem] group-hover:ml-[5px] transition-all duration-300" />
                                        </button>
                                    </div>
                                </div>
                                <div className="flex float-start gap-[10px] group">
                                    <img
                                        src="https://i.ibb.co/6bGWgp6/icon-logo-container-2.png"
                                        alt="image"
                                        className="w-[30px] h-[30px]"
                                    />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">CMS</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>

                                        <button className="text-[#8B5CF6] mt-2 flex items-center gap-[4px] text-[0.9rem]">
                                            Call to action
                                            <MdOutlineArrowRightAlt className="text-[1.4rem] group-hover:ml-[5px] transition-all duration-300" />
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div className="flex flex-col gap-[20px]">
                                <h3 className="text-[1.2rem] text-gray-500 font-[500]">Ecosystem</h3>

                                <div className="flex float-start gap-[10px]">
                                    <BsBuildings className="text-[1.4rem] text-gray-600" />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">Directory</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>
                                    </div>
                                </div>
                                <div className="flex float-start gap-[10px]">
                                    <BsCalendar2Date className="text-[1.4rem] text-gray-600" />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500] ">Bookings</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>
                                    </div>
                                </div>
                                <div className="flex float-start gap-[10px]">
                                    <TbUsersGroup className="text-[1.4rem] text-gray-600" />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">User feedback</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>
                                    </div>
                                </div>
                                <div className="flex float-start gap-[10px]">
                                    <FaTasks className="text-[1.4rem] text-gray-600" />

                                    <div>
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">Task Manager</h1>
                                        <p className="text-[0.9rem] text-gray-400 font-[300]">
                                            Lorem ipsum dolor sit amet, consect adipiscing elit
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="flex flex-col gap-[20px] bg-gray-50 rounded-md p-[20px] w-full">
                            <div className="flex float-start gap-[10px] group">
                                <img
                                    src="https://i.ibb.co/VTqw5rY/img-container.png"
                                    alt="image"
                                    className="w-[100px]"
                                />

                                <div>
                                    <div className="mb-2 flex items-center gap-[5px]">
                                        <h1 className="text-[1rem] text-gray-600 font-[500]">Check the new app</h1>
                                        <p className="py-[3px] px-[8px] text-[0.6rem] text-gray-500 border border-gray-300 rounded-full text-center">
                                            Featured
                                        </p>
                                    </div>
                                    <p className="text-[0.9rem] text-gray-400 font-[300]">
                                        Lorem ipsum dolor sit amet, consect adipiscing elit
                                    </p>

                                    <button className="text-[#FF5E5E] mt-2 flex items-center gap-[4px] text-[0.9rem]">
                                        Call to action
                                        <MdOutlineArrowRightAlt className="text-[1.4rem] group-hover:ml-[5px] transition-all duration-300" />
                                    </button>
                                </div>
                            </div>
                            <div className="flex float-start gap-[10px] group">
                                <img
                                    src="https://i.ibb.co/V2b5xnK/img-container-1.png"
                                    alt="image"
                                    className="w-[100px]"
                                />

                                <div>
                                    <h1 className="text-[1rem] text-gray-600 font-[500]">Check our newsletter</h1>
                                    <p className="text-[0.9rem] text-gray-400 font-[300]">
                                        Lorem ipsum dolor sit amet, consect adipiscing elit
                                    </p>

                                    <button className="text-[#FF5E5E] mt-2 flex items-center gap-[4px] text-[0.9rem]">
                                        Call to action
                                        <MdOutlineArrowRightAlt className="text-[1.4rem] group-hover:ml-[5px] transition-all duration-300" />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div> */}
                </li>
                <li
                    onClick={() => navigate("/van-ban-quy-pham-phap-luat")}
                    className="flex items-center gap-[5px] cursor-pointer"
                >
                    <FontAwesomeIcon icon={faBook} className="text-[1.1rem] text-gray-600" />
                    Văn Bản
                </li>

                <li className="flex items-center gap-[5px] cursor-pointer" onClick={() => navigate("/chatbot")}>
                    <FontAwesomeIcon icon={faComments} className="text-[1.1rem] text-gray-600" />
                    Chatbot
                </li>
                <li className="flex items-center gap-[5px] cursor-pointer">
                    <FontAwesomeIcon icon={faBars} className="text-[1.1rem] text-gray-600" />
                    Khác
                </li>
            </ul>

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
                            accountMenuOpen ? "translate-y-0 opacity-100 z-[1]" : "translate-y-[10px] opacity-0 z-[-1]"
                        } bg-white w-max rounded-md boxShadow absolute top-[45px] right-0 p-[10px] flex flex-col transition-all duration-300 gap-[5px]`}
                    >
                        <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50">
                            <FiUser />
                            View Profile
                        </p>
                        <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50">
                            <IoSettingsOutline />
                            Settings
                        </p>
                        <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50">
                            <FiUser />
                            View Profile
                        </p>

                        <div className="mt-3 border-t border-gray-200 pt-[5px]">
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

            <aside
                className={` ${
                    mobileSidebarOpen ? "translate-x-0 opacity-100 z-20" : "translate-x-[200px] opacity-0 z-[-1]"
                } lg:hidden bg-white boxShadow p-4 text-center absolute top-[55px] right-0 sm:w-[300px] w-full rounded-md transition-all duration-300`}
            >
                <ul className="items-start gap-[20px] text-[1rem] text-gray-600 flex flex-col">
                    <li
                        onClick={() => setProductMobileMegaMenu(!productMobileMegaMenu)}
                        className="hover:text-[#3B9DF8] group transition-all duration-500 cursor-pointer capitalize flex items-center gap-[10px]"
                    >
                        Products
                        <IoIosArrowDown
                            className={`${
                                productMobileMegaMenu ? "rotate-0" : "rotate-[180deg]"
                            } text-gray-600 group-hover:text-[#3B9DF8] transition-all duration-300`}
                        />
                    </li>

                    {/* product mega menu */}
                    <div
                        onClick={() => setMegaMenuSubItem("more_product")}
                        className={`${productMobileMegaMenu ? "hidden" : "block"} group font-[500] ml-6`}
                    >
                        <h4 className="text-left flex items-center gap-[5px]">
                            More Products
                            <MdOutlineKeyboardArrowRight className="text-[1.2rem]" />
                        </h4>

                        <ul
                            className={`${
                                megaMenuSubItem === "more_product" ? "flex" : "hidden"
                            } pl-6 mt-3 font-[400] items-start flex-col gap-[10px] text-gray-600`}
                        >
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                Demo App
                            </li>
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                CRM
                            </li>
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                CMS
                            </li>
                        </ul>
                    </div>

                    <div
                        onClick={() => setMegaMenuSubItem("ecosystem")}
                        className={`${productMobileMegaMenu ? "hidden" : "block"} font-[500] ml-6`}
                    >
                        <h4 className="text-left flex items-center gap-[5px]">
                            Ecosystem
                            <MdOutlineKeyboardArrowRight className="text-[1.2rem]" />
                        </h4>

                        <ul
                            className={`${
                                megaMenuSubItem === "ecosystem" ? "flex" : "hidden"
                            } pl-6 mt-3 font-[400] items-start flex-col gap-[10px] text-gray-600`}
                        >
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                Directory
                            </li>
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                Bookings
                            </li>
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                User feedback
                            </li>
                            <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                                Task Manager
                            </li>
                        </ul>
                    </div>

                    <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-poin ter capitalize">
                        Features
                    </li>
                    <li className="hover:text-[#3B9DF8] transition-all duration-500 cursor-pointer capitalize">
                        Support
                    </li>
                </ul>
            </aside>
        </nav>
    );
}

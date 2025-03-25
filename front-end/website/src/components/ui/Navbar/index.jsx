import React, { memo, useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, Close } from "@mui/icons-material";
import { Link, useLocation } from "react-router-dom";
import { FaUserCircle } from "react-icons/fa";
import { IoMenu } from "react-icons/io5";

const NavLink = memo(({ href, children, className = "" }) => (
    <motion.a
        href={href}
        className={`hover:text-blue-600 transition-colors duration-200 whitespace-nowrap ${className}`}
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
    >
        {children}
    </motion.a>
));

const Navbar = memo(() => {
    const [isScrolled, setIsScrolled] = useState(false);
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
    const location = useLocation();
    const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

    useEffect(() => {
        const handleScroll = () => {
            setIsScrolled(window.scrollY > 20);
        };

        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    const navItems = [
        { href: "/vbqppl", label: "Văn bản pháp luật" },
        { href: "/chat-bot", label: "Chatbot" },
        { href: "/tree-law", label: "Tra cứu pháp điển" },
        { href: "/", label: "Learn" },
        { href: "/tin-tuc", label: "Tin tức" },
    ];

    const userMenuItems = [
        { label: "Thông tin cá nhân", path: "/profile" },
        { label: "Cài đặt", path: "/settings" },
        { label: "Đăng xuất", path: "/logout" },
    ];

    return (
        <div className="fixed top-0 left-0 right-0 z-50 flex justify-center">
            <motion.div
                initial={{ y: -100 }}
                animate={{ y: 0 }}
                transition={{ duration: 0.5 }}
                className={`flex items-center justify-between w-full max-w-screen-lg mx-4 px-10 py-4 bg-white rounded-full shadow-lg transition-all duration-300 ${
                    isScrolled ? "shadow-xl" : "shadow-lg"
                }`}
            >
                {/* Logo */}
                <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ duration: 0.5, delay: 0.2 }}
                    className="text-2xl font-bold text-black"
                >
                    LegalWise
                </motion.div>

                {/* Desktop Navigation */}
                <div className="items-center hidden md:flex gap-x-12">
                    {navItems.map((item, index) => (
                        <NavLink
                            key={item.label}
                            href={item.href}
                            className="text-gray-600"
                            initial={{ opacity: 0, y: -20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ duration: 0.3, delay: 0.1 * index }}
                        >
                            {item.label}
                        </NavLink>
                    ))}
                </div>

                {/* User Profile Section */}
                <div className="items-center hidden space-x-4 md:flex">
                    <div className="relative">
                        <motion.button
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setIsUserMenuOpen(!isUserMenuOpen)}
                            className="flex items-center space-x-2 text-gray-700 hover:text-[#1bddff] transition-colors duration-200"
                        >
                            <FaUserCircle className="w-6 h-6" />
                            <span className="text-sm font-medium">John Doe</span>
                        </motion.button>

                        {/* User Dropdown Menu */}
                        <AnimatePresence>
                            {isUserMenuOpen && (
                                <motion.div
                                    initial={{ opacity: 0, y: -10 }}
                                    animate={{ opacity: 1, y: 0 }}
                                    exit={{ opacity: 0, y: -10 }}
                                    transition={{ duration: 0.2 }}
                                    className="absolute right-0 w-48 py-2 mt-2 bg-white rounded-lg shadow-lg"
                                >
                                    {userMenuItems.map((item) => (
                                        <Link
                                            key={item.path}
                                            to={item.path}
                                            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-[#1bddff] transition-colors duration-200"
                                            onClick={() => setIsUserMenuOpen(false)}
                                        >
                                            {item.label}
                                        </Link>
                                    ))}
                                </motion.div>
                            )}
                        </AnimatePresence>
                    </div>
                </div>

                {/* Mobile Menu Button */}
                <motion.button
                    whileTap={{ scale: 0.95 }}
                    className="p-2 rounded-lg md:hidden hover:bg-gray-100"
                    onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                >
                    {isMobileMenuOpen ? (
                        <Close className="w-6 h-6 text-gray-600" />
                    ) : (
                        <Menu className="w-6 h-6 text-gray-600" />
                    )}
                </motion.button>

                {/* Mobile Navigation */}
                <AnimatePresence>
                    {isMobileMenuOpen && (
                        <motion.div
                            initial={{ opacity: 0, y: -20 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, y: -20 }}
                            transition={{ duration: 0.3, ease: "easeInOut" }}
                            className="fixed inset-0 z-40 bg-white md:hidden"
                        >
                            {/* Mobile Header */}
                            <div className="flex items-center justify-between px-6 py-4 border-b">
                                <motion.div
                                    initial={{ opacity: 0, x: -20 }}
                                    animate={{ opacity: 1, x: 0 }}
                                    transition={{ duration: 0.3, delay: 0.1 }}
                                    className="text-2xl font-bold text-black"
                                >
                                    LegalWise
                                </motion.div>
                                <motion.button
                                    whileTap={{ scale: 0.95 }}
                                    onClick={() => setIsMobileMenuOpen(false)}
                                    className="p-2 rounded-lg hover:bg-gray-100"
                                >
                                    <Close className="w-6 h-6 text-gray-600" />
                                </motion.button>
                            </div>

                            {/* Mobile Menu Content */}
                            <div className="px-6 py-4 space-y-6">
                                {/* Navigation Links */}
                                <div className="space-y-2">
                                    {navItems.map((item, index) => (
                                        <motion.div
                                            key={item.label}
                                            initial={{ opacity: 0, x: -20 }}
                                            animate={{ opacity: 1, x: 0 }}
                                            transition={{ duration: 0.3, delay: 0.1 * (index + 1) }}
                                        >
                                            <NavLink
                                                href={item.href}
                                                className="block px-4 py-3 text-lg font-medium text-gray-700 rounded-lg hover:bg-gray-50 hover:text-[#1bddff] transition-colors duration-200"
                                                onClick={() => setIsMobileMenuOpen(false)}
                                            >
                                                {item.label}
                                            </NavLink>
                                        </motion.div>
                                    ))}
                                </div>

                                {/* User Profile Section */}
                                <motion.div
                                    initial={{ opacity: 0, y: 20 }}
                                    animate={{ opacity: 1, y: 0 }}
                                    transition={{ duration: 0.3, delay: 0.4 }}
                                    className="pt-4 border-t"
                                >
                                    <div className="flex items-center px-4 py-3 space-x-3">
                                        <FaUserCircle className="w-8 h-8 text-gray-600" />
                                        <div>
                                            <div className="text-lg font-medium text-gray-800">John Doe</div>
                                            <div className="text-sm text-gray-500">user@example.com</div>
                                        </div>
                                    </div>
                                    <div className="mt-2 space-y-1">
                                        {userMenuItems.map((item, index) => (
                                            <motion.div
                                                key={item.path}
                                                initial={{ opacity: 0, x: -20 }}
                                                animate={{ opacity: 1, x: 0 }}
                                                transition={{ duration: 0.3, delay: 0.1 * (index + 1) }}
                                            >
                                                <Link
                                                    to={item.path}
                                                    className="block px-4 py-3 text-base text-gray-600 rounded-lg hover:bg-gray-50 hover:text-[#1bddff] transition-colors duration-200"
                                                    onClick={() => setIsMobileMenuOpen(false)}
                                                >
                                                    {item.label}
                                                </Link>
                                            </motion.div>
                                        ))}
                                    </div>
                                </motion.div>
                            </div>
                        </motion.div>
                    )}
                </AnimatePresence>
            </motion.div>
        </div>
    );
});

Navbar.displayName = "Navbar";

export default Navbar;

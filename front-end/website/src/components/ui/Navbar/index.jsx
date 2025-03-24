import React, { memo, useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, Close } from "@mui/icons-material";

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

    useEffect(() => {
        const handleScroll = () => {
            setIsScrolled(window.scrollY > 20);
        };

        window.addEventListener("scroll", handleScroll);
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    const navItems = [
        { href: "/", label: "Legal Forms" },
        { href: "/", label: "Services" },
        { href: "/", label: "State Laws" },
        { href: "/", label: "Learn" },
        { href: "/", label: "Blogs" },
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
                            initial={{ opacity: 0, height: 0 }}
                            animate={{ opacity: 1, height: "auto" }}
                            exit={{ opacity: 0, height: 0 }}
                            transition={{ duration: 0.3 }}
                            className="absolute left-0 right-0 mt-2 bg-white rounded-lg shadow-lg top-full md:hidden"
                        >
                            <div className="p-4 space-y-4">
                                {navItems.map((item, index) => (
                                    <NavLink
                                        key={item.label}
                                        href={item.href}
                                        className="block text-gray-600"
                                        initial={{ opacity: 0, x: -20 }}
                                        animate={{ opacity: 1, x: 0 }}
                                        transition={{ duration: 0.3, delay: 0.1 * index }}
                                    >
                                        {item.label}
                                    </NavLink>
                                ))}
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

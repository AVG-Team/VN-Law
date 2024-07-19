import Cookies from "js-cookie";
import { Fragment, useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import Logo from "../../../assets/images/logo/logo2.png";
import { StorageKeys } from "../../../common/constants/keys";
import { Disclosure, Menu, Transition } from "@headlessui/react";
import { menus, pages, toggleButton } from "../../../mock/header.data";
import { Bars3Icon, BellIcon, XMarkIcon, UserCircleIcon } from "@heroicons/react/24/outline";
import { getUserInfo } from "../../../mock/auth";
import { debounce } from "lodash";

function classNames(...classes) {
    return classes.filter(Boolean).join(" ");
}

export function Navbar() {
    const location = useLocation();
    const isAuthenticated = !!Cookies.get(StorageKeys.ACCESS_TOKEN);

    const [isSticky, setIsSticky] = useState(false);


    window.addEventListener("scroll", () => {
        console.log(231423423);
    });
    
    useEffect(() => {
        const handleScroll = () => {
            console.log('scrolling');
        };

        window.addEventListener("scroll", () => {
            console.log(231423423);
        });
        window.addEventListener("scroll", handleScroll);
    }, []);

    const handleLogout = () => {
        Cookies.remove(StorageKeys.ACCESS_TOKEN);
    };
    return (
        <Disclosure as="nav" className={`z-99 bg-white fixed top-0 left-0 w-full transition-all duration-300 ease-in-out ${isSticky ? 'bg-gray-800 shadow-lg' : 'bg-transparent'}`}>
            {({ open }) => (
                <>
                    <div className="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
                        <div className="flex justify-between h-16">
                            <div className="flex">
                                <div className="flex items-center mr-2 -ml-2 md:hidden">
                                    {/* Mobile menu button */}
                                    <Disclosure.Button
                                        className="z-99999 block rounded-sm border border-stroke bg-white p-1.5 shadow-sm">
                                        {/*<span className="absolute -inset-0.5" />*/}
                                        {/*<span className="sr-only">Mở Menu</span>*/}
                                        {/*{open ? (*/}
                                        {/*    <XMarkIcon className="block w-6 h-6" aria-hidden="true" />*/}
                                        {/*) : (*/}
                                        {/*    <Bars3Icon className="block w-6 h-6" aria-hidden="true" />*/}
                                        {/*)}*/}
                                        <span className="relative block h-6 w-6 cursor-pointer">
                                          <span className="du-block absolute right-0 h-full w-full">
                                            <span
                                                className={`relative left-0 top-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-[0] duration-200 ease-in-out ${
                                                    !open && "!w-full delay-300"
                                                }`}
                                            ></span>
                                            <span
                                                className={`relative left-0 top-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-150 duration-200 ease-in-out ${
                                                    !open && "delay-400 !w-full"
                                                }`}
                                            ></span>
                                            <span
                                                className={`relative left-0 top-0 my-1 block h-0.5 w-0 rounded-sm bg-black delay-200 duration-200 ease-in-out ${
                                                    !open && "!w-full delay-500"
                                                }`}
                                            ></span>
                                          </span>
                                          <span className="absolute right-0 h-full w-full rotate-45">
                                            <span
                                                className={`absolute left-2.5 top-0 block h-full w-0.5 rounded-sm bg-black delay-300 duration-200 ease-in-out ${
                                                    !open && "!h-0 !delay-[0]"
                                                }`}
                                            ></span>
                                            <span
                                                className={`delay-400 absolute left-0 top-2.5 block h-0.5 w-full rounded-sm bg-black duration-200 ease-in-out ${
                                                    !open && "!h-0 !delay-200"
                                                }`}
                                            ></span>
                                          </span>
                                        </span>
                                    </Disclosure.Button>
                                </div>
                                <NavLink to={"/"} className="flex items-center flex-shrink-0">
                                    <img className="w-40" src={Logo} alt="Logo" />
                                </NavLink>
                                <div className="hidden md:ml-6 md:flex md:space-x-8">
                                    {pages.map((page) =>
                                        page.href === location.pathname ? (
                                            <a
                                                key={page.key}
                                                href={page.href}
                                                className="inline-flex items-center px-1 pt-1 text-sm font-semibold text-gray-900 border-b-2 border-indigo-500"
                                            >
                                                {page.name}
                                            </a>
                                        ) : (
                                            <a
                                                key={page.key}
                                                href={page.href}
                                                className="inline-flex items-center px-1 pt-1 text-sm font-semibold text-gray-500 border-b-2 border-transparent hover:border-gray-300 hover:text-gray-700"
                                            >
                                                {page.name}
                                            </a>
                                        ),
                                    )}
                                </div>
                            </div>
                            <div className="flex items-center">
                                <div className="flex-shrink-0 hidden md:flex">
                                    {!isAuthenticated ? (
                                        toggleButton.map((button) => (
                                            <NavLink
                                                key={button.id}
                                                type="button"
                                                className="relative inline-flex items-center gap-x-1.5 rounded-md bg-indigo-600 mr-1 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                                                to={button.link}
                                            >
                                                {button.name}
                                            </NavLink>
                                        ))
                                    ) : null}
                                </div>
                                <div className="hidden md:ml-4 md:flex md:flex-shrink-0 md:items-center">
                                    {isAuthenticated ? (
                                        <button
                                            type="button"
                                            className="relative p-1 text-gray-400 bg-white rounded-full hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                                        >
                                            <span className="absolute -inset-1.5" />
                                            <span className="sr-only">View notifications</span>
                                            <BellIcon className="w-6 h-6" aria-hidden="true" />
                                        </button>
                                    ) : null}

                                    {/* Profile dropdown */}
                                    {isAuthenticated ? (
                                        <Menu as="div" className="relative ml-3">
                                            <div>
                                                <Menu.Button className="relative flex text-sm bg-white rounded-full"
                                                             onDoubleClick={(event) => event.stopPropagation()}>
                                                    <span className="absolute -inset-1.5" />
                                                    <span className="sr-only">Mở Menu Cá Nhân</span>
                                                    <UserCircleIcon
                                                        className="w-7 h-7 opacity-40 hover:opacity-70 transition-opacity"
                                                        aria-hidden={true} />
                                                </Menu.Button>
                                            </div>
                                            <Transition
                                                as={Fragment}
                                                enter="transition ease-out duration-200"
                                                enterFrom="transform opacity-0 scale-95"
                                                enterTo="transform opacity-100 scale-100"
                                                leave="transition ease-in duration-75"
                                                leaveFrom="transform opacity-100 scale-100"
                                                leaveTo="transform opacity-0 scale-95"
                                            >
                                                <Menu.Items
                                                    className="absolute right-0 z-10 w-48 py-1 mt-2 origin-top-right bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                                                    {menus.map((menu) => (
                                                        <Menu.Item key={menu.name}>
                                                            {({ active }) => (
                                                                <a
                                                                    href={menu.href}
                                                                    onClick={menu.name === 3 ? handleLogout : null}
                                                                    className={classNames(
                                                                        active ? "bg-gray-100" : "",
                                                                        "block px-4 py-2 text-sm text-gray-700",
                                                                    )}
                                                                >
                                                                    {menu.name}
                                                                </a>
                                                            )}
                                                        </Menu.Item>
                                                    ))}
                                                </Menu.Items>
                                            </Transition>
                                        </Menu>
                                    ) : null}
                                </div>
                            </div>
                        </div>
                    </div>
                    <Transition
                        show={open}
                        enter="transition duration-100 ease-out"
                        enterFrom="transform scale-95 opacity-0"
                        enterTo="transform scale-100 opacity-100"
                        leave="transition duration-75 ease-out"
                        leaveFrom="transform scale-100 opacity-100"
                        leaveTo="transform scale-95 opacity-0"
                    >
                    <Disclosure.Panel static className="md:hidden">
                        <div className="pt-2 pb-3 space-y-1">
                            {pages.map((page) =>
                                page.href === location.pathname ? (
                                    <Disclosure.Button
                                        as="a"
                                        href={page.href}
                                        key={page.key}
                                        className="block py-2 pl-3 pr-4 text-base font-semibold text-indigo-700 border-l-4 border-indigo-500 bg-indigo-50 sm:pl-5 sm:pr-6"
                                    >
                                        {page.name}
                                    </Disclosure.Button>
                                ) : (
                                    <Disclosure.Button
                                        as="a"
                                        href={page.href}
                                        key={page.key}
                                        className="block py-2 pl-3 pr-4 text-base font-semibold text-gray-500 border-l-4 border-transparent hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700 sm:pl-5 sm:pr-6"
                                    >
                                        {page.name}
                                    </Disclosure.Button>
                                ),
                            )}
                        </div>
                        {isAuthenticated ? (
                            <div className="pt-4 pb-3 border-t border-gray-200">
                                <div className="flex items-center px-4 sm:px-6">
                                    <div className="flex-shrink-0">
                                        <UserCircleIcon className="w-10 h-10 text-gray-400" aria-hidden="true" />
                                    </div>
                                    <div className="ml-3">
                                        <div
                                            className="text-base font-semibold text-gray-800">{getUserInfo().name}</div>
                                        <div className="text-sm font-semibold text-gray-500">{getUserInfo().role}</div>
                                    </div>
                                    <button
                                        type="button"
                                        className="relative flex-shrink-0 p-1 ml-auto text-gray-400 bg-white rounded-full hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                                    >
                                        <span className="absolute -inset-1.5" />
                                        <span className="sr-only">View notifications</span>
                                        <BellIcon className="w-6 h-6" aria-hidden="true" />
                                    </button>
                                </div>
                                <div className="mt-3 space-y-1">
                                    {menus.map((item) => (
                                        <Disclosure.Button
                                            as="a"
                                            href={item.href}
                                            key={item.key}
                                            onClick={item.key === 3 ? handleLogout : null}
                                            className="block px-4 py-2 text-base font-semibold text-gray-500 hover:bg-gray-100 hover:text-gray-800 sm:px-6"
                                        >
                                            {item.name}
                                        </Disclosure.Button>
                                    ))}
                                </div>
                            </div>
                        ) : (
                            <div className="pb-3 border-t border-gray-200">
                                <div className="mt-3 space-y-1">
                                    {toggleButton.map((button) => (
                                        <Disclosure.Button
                                            as={NavLink}
                                            to={button.link}
                                            key={button.id}
                                            className="block px-4 py-2 text-base font-semibold text-gray-500 hover:bg-gray-100 hover:text-gray-800 sm:px-6"
                                        >
                                            {button.name}
                                        </Disclosure.Button>
                                    ))}
                                </div>
                            </div>
                        )}
                    </Disclosure.Panel>
                    </Transition>
                </>
            )}
        </Disclosure>
    );
}

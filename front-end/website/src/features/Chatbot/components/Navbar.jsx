import LawQuestions from "./LawQuestions";
import { PencilSquareIcon } from "@heroicons/react/24/solid";

function Navbar({ isOpenMenuNavbar, nameUser, clearMessages }) {
    return (
        <div
            className={`navbar-container ${
                isOpenMenuNavbar ? "open" : "closed"
            } flex flex-col bg-gray-100 lg:w-96 w-[85vw] z-50 pb-2 rounded-t-lg lg:relative h-screen shadow shadow-gray-500 lg:shadow-none`}
        >
            <div className="flex-1 overflow-y-scroll">
                <div
                    className="flex items-center p-3 justify-between rounded-lg hover:bg-slate-300 bg-gray-100 cursor-pointer sticky top-0 left-0 right-0 z-50"
                    onClick={() => {
                        clearMessages();
                    }}
                >
                    <div className="flex items-center">
                        <img src="https://cdn-icons-png.flaticon.com/512/432/432594.png" alt="icon" className="w-8" />
                        <p className="pl-3 text-lg text-black">New Chat</p>
                    </div>
                    <PencilSquareIcon className="w-6 h-6 text-black" />
                </div>
                <div className="px-2">
                    <LawQuestions />
                </div>
            </div>
            <div className="bg-gray-100">
                <div className="hover:bg-slate-300 p-3 rounded-lg mx-3 cursor-pointer flex items-center">
                    <img
                        src="https://github.com/AVG-Team/Website_Course_AVG/blob/master/Content/img/logo/favicon.png?raw=true"
                        alt="icon"
                        className="w-8"
                    />
                    <p className="ml-1 font-bold text-lg">{nameUser}</p>
                </div>
            </div>
        </div>
    );
}

export default Navbar;

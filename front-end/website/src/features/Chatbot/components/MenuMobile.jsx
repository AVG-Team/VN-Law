import { Bars3BottomLeftIcon, PencilSquareIcon } from "@heroicons/react/24/solid";
import VersionChatbot from "./VersionChatbot";

export default function MenuMobile({ isOpenMenuNavbar, setIsOpenMenuNavbar, clearMessages }) {
    return (
        <div className="flex lg:hidden items-center justify-between m-3 sticky">
            <Bars3BottomLeftIcon
                className="w-6 h-6 text-gray-800 cursor-pointer"
                onClick={() => {
                    setIsOpenMenuNavbar(!isOpenMenuNavbar);
                }}
            />
            <VersionChatbot className="flex items-center" />
            <PencilSquareIcon className="w-6 h-6 text-gray-800 cursor-pointer" onClick={clearMessages} />
        </div>
    );
}

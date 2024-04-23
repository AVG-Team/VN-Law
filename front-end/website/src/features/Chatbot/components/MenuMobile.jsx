import { Bars3BottomLeftIcon, PencilSquareIcon } from "@heroicons/react/24/solid";
import VersionChatbot from "./VersionChatbot";
import PropTypes from "prop-types";

MenuMobile.propTypes = {
    isOpenMenuNavbar: PropTypes.bool.isRequired,
    setIsOpenMenuNavbar: PropTypes.func.isRequired,
    clearMessages: PropTypes.func.isRequired,
};

export default function MenuMobile({ isOpenMenuNavbar, setIsOpenMenuNavbar, clearMessages }) {
    return (
        <div className="sticky flex items-center justify-between m-3 lg:hidden">
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

import { PencilSquareIcon } from "@heroicons/react/20/solid";

export default function VersionChatbot({ className, clearMessages, isOpenMenuNavbar }) {
    return (
        <div className={className}>
            <PencilSquareIcon
                className={`w-5 h-5 text-gray-400 cursor-pointer mr-3 hover:text-gray-800 ${
                    isOpenMenuNavbar ? "hidden" : ""
                }`}
                onClick={clearMessages}
            />
            <p className="text-lg font-bold mr-2 text-gray-700">AVG Law </p>
            <p className="text-gray-400 text-lg">1.0</p>
        </div>
    );
}

import React from "react"
import { socialMedidaLinks } from "~/mock/infomationContacts.data"
import { LinkIcon, UserGroupIcon } from "@heroicons/react/24/solid"

function getIcon(platform){
    switch(platform) {
        case "Facebook":
            return <svg width="37px" height="37px" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" fill="none"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier">
                        <path fill="#1877F2" d="M15 8a7 7 0 00-7-7 7 7 0 00-1.094 13.915v-4.892H5.13V8h1.777V6.458c0-1.754 1.045-2.724 2.644-2.724.766 0 1.567.137 1.567.137v1.723h-.883c-.87 0-1.14.54-1.14 1.093V8h1.941l-.31 2.023H9.094v4.892A7.001 7.001 0 0015 8z"></path><path fill="#ffffff" d="M10.725 10.023L11.035 8H9.094V6.687c0-.553.27-1.093 1.14-1.093h.883V3.87s-.801-.137-1.567-.137c-1.6 0-2.644.97-2.644 2.724V8H5.13v2.023h1.777v4.892a7.037 7.037 0 002.188 0v-4.892h1.63z"></path></g>
                    </svg>
        case "Github":
            return <svg fill="currentColor" width="35px" height="35px" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" class="jsx-2529474241">
                        <path fill-rule="evenodd" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z" class="jsx-2529474241"></path>
                    </svg>
        default:
            return <LinkIcon />
    }
}

export function SocialMedidaLinks(){
    return (
        <div className="w-full lg:w-4/12 text-center dark:text-gray-900 justify-center flex flex-row lg:flex-col gap-7 mx-auto mt-5 lg:mt-0 order-1 lg:order-2">
            <div>
                <div className="bg-gray-300 rounded-md p-4 w-16 h-16 flex items-center mx-auto">
                    <UserGroupIcon />
                </div>
                <p className="text-lg font-bold pt-3">Thông tin:</p>
                <p>AVG Team</p>
            </div>
            <div>
                <div className="bg-gray-300 rounded-md p-4 w-16 h-16 flex items-center mx-auto">
                    <LinkIcon/> 
                </div>
                <p className="text-lg font-bold pt-3">Liên kết:</p>
                <div className="flex lg:flex-row justify-center pb-5">
                    {socialMedidaLinks.map((item) => (
                        <a className="px-2" key={item.platform} href={item.url} target="blank">
                            {getIcon(item.platform)}
                        </a>
                    ))}
                </div>
            </div>
        </div>     
    );
};

export default SocialMedidaLinks;
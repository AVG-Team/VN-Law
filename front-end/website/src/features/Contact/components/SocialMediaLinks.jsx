import React from "react"
import { socialMedidaLinks } from "~/mock/infomationContacts.data"
import { LinkIcon, MapPinIcon, UserGroupIcon } from "@heroicons/react/24/solid"

export function SocialMedidaLinks(){
    return (
        <div className="w-full text-center dark:text-gray-900 justify-center flex flex-col lg:flex-row mx-auto gap-7 mt-5 lg:mt-10">
            <div className="lg:w-4/12">
                <div className="bg-gray-300 rounded-md p-4 w-16 h-16 flex items-center mx-auto">
                    <UserGroupIcon />
                </div>
                <p className="text-lg font-bold pt-3">Thông tin Team:</p>
                <p>AVG Team</p>
            </div>
            <div className="lg:w-4/12">
                <div className="bg-gray-300 rounded-md p-4 w-16 h-16 flex items-center mx-auto">
                    <LinkIcon/> 
                </div>
                <p className="text-lg font-bold pt-3">Liên kết:</p>
                <div className="flex flex-col">
                    {socialMedidaLinks.map((item) => (
                        <a key={item.platform} href={item.url} target="blank">{item.url}</a>
                    ))}
                </div>
            </div>
            <div className="lg:w-4/12">
                <div className="bg-gray-300 rounded-md p-4 w-16 h-16 flex items-center mx-auto"> 
                    <MapPinIcon/>                        
                </div>
                <p className="text-lg font-bold pt-3">Địa chỉ:</p>
                <iframe className="mx-auto"
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.427642206537!2d106.78279807580208!3d10.855042689298537!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317527c3debb5aad%3A0x5fb58956eb4194d0!2zxJDhuqFpIEjhu41jIEh1dGVjaCBLaHUgRQ!5e0!3m2!1sen!2s!4v1713204707972!5m2!1sen!2s"
                    width="336"
                    height="150"
                    style={{ border: 0, allowFullScreen: true, loading: "lazy", referrerpolicy: "no-referrer-when-downgrade" }}
                />
            </div>
        </div>     
    );
};

export default SocialMedidaLinks;
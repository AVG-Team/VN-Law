import { faEdit, faPen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React from "react";

export default function Profile() {
    return (
        <div className="min-h-screen p-6 bg-blue-50">
            <div className="max-w-4xl p-6 mx-auto bg-white rounded-lg shadow-md">
                <div className="flex items-center justify-between pb-4 mb-6 border-b">
                    <h1 className="text-2xl font-bold text-gray-700">Cài đặt</h1>
                    <div className="space-x-4">
                        <button className="p-2 font-medium text-white bg-blue-300 rounded-xl">Trang cá nhân</button>
                        <button className="font-medium text-gray-500">Doanh nghiệp</button>
                        <button className="font-medium text-gray-500">Gói đăng ký</button>
                        <button className="font-medium text-gray-500">Thông báo</button>
                    </div>
                </div>

                {/* Tài khoản của bạn */}
                <div className="space-y-6">
                    <h2 className="text-lg font-semibold text-gray-700">Tài khoản của bạn</h2>
                    <div className="p-6 border border-gray-200 rounded-lg">
                        <div className="flex flex-row items-center justify-between mt-2">
                            {/* Hình đại diện */}
                            <div className="flex items-center">
                                <div className="overflow-hidden bg-gray-100 rounded-full w-25 h-25">
                                    <img
                                        src="https://via.placeholder.com/100"
                                        alt="Ảnh đại diện"
                                        className="object-cover w-full h-full"
                                    />
                                </div>
                                <p className="ml-4 text-gray-500">Định dạng hình ảnh JPEG, PNG, tối đa 2MB</p>
                            </div>

                            {/* Nút chỉnh sửa */}
                            <button className="px-4 py-2 text-gray-400 border border-gray-300 rounded-lg">
                                Chỉnh sửa
                                <FontAwesomeIcon icon={faPen} className="w-4 h-4 ms-2" />
                            </button>
                        </div>
                    </div>

                    {/* Thông tin cá nhân */}
                    <div className="p-6 border border-gray-200 rounded-lg">
                        <div className="flex justify-between">
                            <h2 className="text-lg font-semibold text-gray-700">Thông tin cá nhân</h2>
                            <button className="px-4 py-2 text-gray-400 border border-gray-300 rounded-lg">
                                Chỉnh sửa
                                <FontAwesomeIcon icon={faPen} className="w-4 h-4 ms-2" />
                            </button>
                        </div>

                        <div className="grid grid-cols-2 gap-4 mt-4">
                            <div>
                                <p className="text-sm text-gray-500">Họ và tên</p>
                                <p className="font-medium text-gray-700">7564_Nguyễn Mai Bảo Huy</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-500">Email</p>
                                <p className="font-medium text-gray-700">nguyenmaibaohuy2003@gmail.com</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-500">Số điện thoại</p>
                                <p className="font-medium text-gray-700">---</p>
                            </div>
                            <div>
                                <p className="text-sm text-gray-500">Địa chỉ</p>
                                <p className="font-medium text-gray-700">---</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}

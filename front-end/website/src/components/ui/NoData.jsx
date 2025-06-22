import React from "react";
import { Empty, Button } from "antd";
import { RefreshCw, Search, Plus } from "lucide-react";

const NoDataPage = ({
    title = "Không có dữ liệu",
    description = "Hiện tại chưa có dữ liệu để hiển thị",
    showRefreshButton = true,
    showSearchButton = false,
    showAddButton = false,
    onRefresh,
    onSearch,
    onAdd,
    customIcon,
    size = "default", // "small", "default", "large"
}) => {
    const getSizeClasses = () => {
        switch (size) {
            case "small":
                return "py-8";
            case "large":
                return "py-24";
            default:
                return "py-16";
        }
    };

    const getImageSize = () => {
        switch (size) {
            case "small":
                return { width: 120, height: 120 };
            case "large":
                return { width: 200, height: 200 };
            default:
                return { width: 160, height: 160 };
        }
    };

    return (
        <div className={`flex flex-col items-center justify-center ${getSizeClasses()} px-4`}>
            <div className="max-w-md mx-auto text-center">
                {/* Empty illustration */}
                <div className="mb-6">
                    <Empty
                        image={customIcon || Empty.PRESENTED_IMAGE_DEFAULT}
                        imageStyle={getImageSize()}
                        description={false}
                    />
                </div>

                {/* Title */}
                <h3 className="mb-3 text-xl font-semibold text-gray-800">{title}</h3>

                {/* Description */}
                <p className="mb-8 leading-relaxed text-gray-500">{description}</p>

                {/* Action buttons */}
                <div className="flex flex-col justify-center gap-3 sm:flex-row">
                    {showRefreshButton && (
                        <Button
                            type="primary"
                            icon={<RefreshCw className="w-4 h-4" />}
                            onClick={onRefresh}
                            className="flex items-center gap-2"
                        >
                            Làm mới
                        </Button>
                    )}

                    {showSearchButton && (
                        <Button
                            icon={<Search className="w-4 h-4" />}
                            onClick={onSearch}
                            className="flex items-center gap-2"
                        >
                            Tìm kiếm
                        </Button>
                    )}

                    {showAddButton && (
                        <Button
                            type="dashed"
                            icon={<Plus className="w-4 h-4" />}
                            onClick={onAdd}
                            className="flex items-center gap-2"
                        >
                            Thêm mới
                        </Button>
                    )}
                </div>
            </div>
        </div>
    );
};

export default NoDataPage;

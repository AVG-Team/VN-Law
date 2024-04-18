import { useEffect, useState } from "react";
import { vbqppl } from "~/mock/vbqppl.data";
import { DocumentIcon } from "@heroicons/react/24/solid";
import linkFile from "./components/linkFile";

export default function VBQPPL(props) {
    const [isValueCategory, setIsValueCategory] = useState(false);
    const [nameFilter, setNameFilter] = useState("");
    const [categoryFilter, setCategoryFilter] = useState("");

    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";
    }, [title]);

    const categories = [
        { id: "1", name: "Lâm nghiệp" },
        { id: "2", name: "Đất đai - Nhà ở" },
        { id: "3", name: "Thông tin - Truyền thông" },
        { id: "4", name: "Dân số - Phát triển" },
        { id: "5", name: "Xã hội" },
        { id: "6", name: "Chính trị" },
        { id: "7", name: "Hành chính" },
        { id: "8", name: "CNTT" },
        { id: "99", name: "Văn bản khác" },
    ];

    const filterItems = (item) => {
        const matchesName = item.title.toLowerCase().includes(nameFilter.toLowerCase());
        if (categoryFilter === "-1") {
            return matchesName;
        } else {
            const matchesCategory =
                categoryFilter === "" ||
                getCategoryNameById(categoryFilter).toLowerCase() === item.category.toLowerCase();
            return matchesName && matchesCategory;
        }
    };

    const getCategoryNameById = (categoryId) => {
        const category = categories.find((cat) => cat.id === categoryId);
        return category ? category.name : "Văn bản khác";
    };

    const handleChangeCategory = (e) => {
        setCategoryFilter(e.target.value);
        if (e.target.value === "-1") {
            setIsValueCategory(false);
        } else {
            setIsValueCategory(true);
        }
    };

    return (
        <div className="lg:px-20 px-10 py-8">
            <div>
                <p className="text-2xl font-bold">Xem danh sách các văn bản quy phạm pháp luật</p>
                <p className="italic text-sm">
                    *Nhiều văn bản pháp luật hiện nay vẫn chưa được pháp điển hoá cụ thể. Dưới đây là chỉ sự sắp xếp
                    nhưng văn bản đó do hệ thống tự tính toán, không phải chính thức từ chính chủ*
                </p>
            </div>
            <div className="grid lg:grid-cols-3 grid-cols-2 lg:gap-4 gap-2 mt-3">
                <select
                    name="category"
                    id="search_category"
                    value={categoryFilter}
                    className={`rounded-md border-0 p-1.5 shadow-sm ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 ${
                        isValueCategory ? "text-gray-900" : "text-gray-400"
                    }`}
                    onChange={handleChangeCategory}
                >
                    <option value="-1" className="text-gray-400">
                        Tìm kiếm theo thể loại...
                    </option>
                    {categories.map((item) => (
                        <option key={item.id} value={item.id} className="text-gray-900">
                            {item.name}
                        </option>
                    ))}
                </select>
                <input
                    name="name"
                    id="search_name"
                    placeholder="Tìm kiếm theo tên..."
                    value={nameFilter}
                    onChange={(e) => setNameFilter(e.target.value)}
                    className="rounded-md border-0 p-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                />
            </div>
            <div className="grid lg:grid-cols-3 grid-cols-1 lg:gap-4 mt-3">
                {vbqppl.filter(filterItems).map((item) => (
                    <a
                        key={item.id}
                        className="border border-gray-300 rounded-md p-3 my-3 hover:shadow-md transition duration-300 ease-in-out flex flex-col justify-around"
                        href={`/vbqppl/${item.number.replace(/\//g, "_")}`}
                    >
                        <p className="font-bold">{item.title}</p>
                        <p className="text-sm text-gray-500">{item.number}</p>
                        <p className="text-sm text-gray-500">{item.category}</p>
                        <a
                            href={linkFile(item.file)}
                            target="_blank"
                            rel="noreferrer"
                            download={linkFile(item.file)}
                            className="text-blue-500 flex items-center justify-center mt-4 hover:text-blue-700"
                        >
                            <DocumentIcon className="w-6 h-6" />
                            Tải xuống văn bản
                        </a>
                    </a>
                ))}
            </div>
        </div>
    );
}

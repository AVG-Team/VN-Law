import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { vbqppl } from "~/mock/vbqppl.data";
import { Worker } from "@react-pdf-viewer/core";
import Localization from "./components/Localization";
import { DocumentIcon, ArrowDownTrayIcon, EyeIcon } from "@heroicons/react/24/solid";
import linkFile from "./components/linkFile";
import "./components/style.css";
import "@react-pdf-viewer/core/lib/styles/index.css";
import "@react-pdf-viewer/default-layout/lib/styles/index.css";

const truncateText = (text, maxLength) => {
    if (text.length > maxLength) {
        return text.substr(0, maxLength) + "...";
    }
    return text;
};

export default function Detail(props) {
    const [isViewPdf, setIsViewPdf] = useState(false);
    let { param } = useParams();
    const number = param.replace(/_/g, "/");

    const item = vbqppl.find((item) => item.number === number);
    const fileUrl = linkFile(item.file);
    const title = truncateText(item.title, 40);
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";
    }, [title]);

    const handleViewPDF = () => {
        if (!isViewPdf) {
            setIsViewPdf(true);
        }
    };

    return (
        <div className="lg:px-20 px-10 py-8 detail">
            <div className="info">
                <h2 className="text-xl font-bold">{item.title}</h2>
                <table className="w-full border-collapse content border mt-5">
                    <tbody>
                        <tr>
                            <td>Số Hiệu</td>
                            <td>{item.number}</td>
                        </tr>
                        <tr>
                            <td>Loại văn bản</td>
                            <td>{item.category}</td>
                        </tr>
                        <tr>
                            <td>Tài liệu đính kèm</td>
                            <td className="flex items-center">
                                <a
                                    href={fileUrl}
                                    target="_blank"
                                    rel="noreferrer"
                                    download={fileUrl}
                                    className="flex text-blue-500 hover:text-blue-700 items-center"
                                >
                                    <DocumentIcon className="w-4 h-4 mr-3" />
                                    <p>Tải xuống văn bản</p>
                                    <ArrowDownTrayIcon className="w-4 h-4 ml-3" />
                                </a>
                                <EyeIcon
                                    className={`w-6 h-6 ml-3 cursor-pointer opacity-90 hover:opacity-1 hover:text-blue-700 ${
                                        isViewPdf ? "text-blue-700" : ""
                                    }`}
                                    onClick={handleViewPDF}
                                />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            {isViewPdf && (
                <div className="container w-full flex justify-center mt-5">
                    <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.4.120/build/pdf.worker.min.js">
                        <Localization fileUrl={fileUrl} />
                    </Worker>
                </div>
            )}
        </div>
    );
}

import "./components/style.css";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { Worker } from "@react-pdf-viewer/core";
import VbqpplApi from "~/api/law-service/vbqpplApi";
import "@react-pdf-viewer/core/lib/styles/index.css";
import "@react-pdf-viewer/default-layout/lib/styles/index.css";
import { DocumentIcon, ArrowDownTrayIcon, EyeIcon } from "@heroicons/react/24/solid";
import Localization from "./components/Localization";

export default function Detail(props) {
    const [isViewPdf, setIsViewPdf] = useState(false);
    const [vbqppl, setVbqppl] = useState([]);
    let { param } = useParams();
    const id = param;

    useEffect(() => {
        const fetchData = async () => {
            const data = await VbqpplApi.getById(id);
            console.log(data);
            setVbqppl(data);
        };
        fetchData();
    }, [id]);

    const handleViewPDF = () => {
        if (!isViewPdf) {
            setIsViewPdf(true);
        }
    };

    return (
        <div className="px-10 py-8 lg:px-20 detail">
            <div className="flex justify-center info">
                <h2 className="text-xl font-bold">{vbqppl.title}</h2>
                <table className="w-[70%] mt-5 border border-collapse content">
                    <thead>
                        <tr>
                            <th>Thông tin</th>
                            <th>Nội dung</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Số Hiệu</td>
                            <td>{vbqppl.number}</td>
                        </tr>
                        <tr>
                            <td>Loại văn bản</td>
                            <td>{vbqppl.type}</td>
                        </tr>
                        <tr>
                            <td>Tài liệu đính kèm</td>
                            <td className="flex items-center">
                                <button className="flex items-center text-blue-500 hover:text-blue-700">
                                    <DocumentIcon className="w-4 h-4 mr-3" />
                                    <p>Tải xuống văn bản</p>
                                    <ArrowDownTrayIcon className="w-4 h-4 ml-3" />
                                </button>
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
                <div className="container flex justify-center w-full mt-5">
                    <Worker workerUrl="https://unpkg.com/pdfjs-dist@3.4.120/build/pdf.worker.min.js">
                        <Localization item={vbqppl.html} />
                    </Worker>
                </div>
            )}
        </div>
    );
}

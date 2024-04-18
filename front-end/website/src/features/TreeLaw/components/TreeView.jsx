import { Card } from "@mui/material";
import { Tree } from "antd";
export default function TreeView() {
    return (
        <div className="mt-2 ml-5 position-sticky">
            <Card className="h-full ml-2 border border-slate-200">
                <div className="text-center border-b-2 border-slate-200">
                    <h3 className="my-3 ml-2 font-semibold ">Mục lục Pháp Điển</h3>
                </div>
                <Tree />
            </Card>
        </div>
    );
}

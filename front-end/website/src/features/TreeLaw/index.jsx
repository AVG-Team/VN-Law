import TreeView from "./components/TreeView";
import Paper from "@mui/material/Paper";
import Divider from "@mui/material/Divider";
import InputBase from "@mui/material/InputBase";
import IconButton from "@mui/material/IconButton";
import { MagnifyingGlassIcon } from "@heroicons/react/20/solid";
import { Card } from "@mui/material";

const Input = () => {
    return (
        <Paper component="form" className="px-[2px] py-[2px] flex items-center w-[300px] md:w-full">
            <InputBase
                sx={{ ml: 1, flex: 1 }}
                placeholder="Tìm kiếm văn bản pháp luật"
                inputProps={{ "aria-label": "search google maps" }}
                className="flex-1 ml-1"
            />
            <Divider sx={{ height: 28, m: 0.5 }} orientation="vertical" />
            <IconButton type="button" className="w-8 h-8 hover:!bg-slate-200" aria-label="search">
                <MagnifyingGlassIcon />
            </IconButton>
        </Paper>
    );
};

export default function TreeLaw() {
    return (
        <main>
            <div className="grid grid-cols-4 gap-4 mt-2">
                <TreeView />
                <Card className="col-span-3 mt-2 mr-5 border border-slate-200">
                    <div className="mx-2 mt-2 ">
                        <Input />
                    </div>
                </Card>
            </div>
        </main>
    );
}

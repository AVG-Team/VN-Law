import TreeView from "./components/TreeView";
import { Card } from "@mui/material";
import Reader from "./components/Reader";
import { useState } from "react";

export default function TreeLaw() {
    const [chapterSelected, setChapterSelected] = useState(null);
    return (
        <main>
            <div className="grid grid-cols-4 gap-4 mt-2">
                <TreeView setChapterSelected={setChapterSelected} />
                <Card className="col-span-3 mt-2 mr-5 border border-slate-200">
                    <div className="mx-2 mt-2 ">
                        <Reader selectedChapter={chapterSelected} setChapterSelected={setChapterSelected} />
                    </div>
                </Card>
            </div>
        </main>
    );
}

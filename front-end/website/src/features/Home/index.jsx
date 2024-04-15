import React from "react";
import Paper from "@mui/material/Paper";
import { Container } from "@mui/material";
import Divider from "@mui/material/Divider";
import InputBase from "@mui/material/InputBase";
import IconButton from "@mui/material/IconButton";
import NavigatorCard from "./components/NavigatorCard.jsx";
import { NavigatorCardData } from "../../mock/Home.data.js";
import { MagnifyingGlassIcon } from "@heroicons/react/20/solid";

const Input = () => {
    return (
        <Paper component="form" sx={{ p: "2px 4px", display: "flex", alignItems: "center", width: 400 }}>
            <InputBase
                sx={{ ml: 1, flex: 1 }}
                placeholder="Tìm kiếm văn bản pháp luật..."
                inputProps={{ "aria-label": "search google maps" }}
            />
            <Divider sx={{ height: 28, m: 0.5 }} orientation="vertical" />
            <IconButton type="button" className="w-8 h-8" aria-label="search">
                <MagnifyingGlassIcon />
            </IconButton>
        </Paper>
    );
};
export default function Home() {
    return (
        <main>
            <Container className="mt-4">
                <div className="grid-cols-3 ">
                    <div className="text-center ">
                        <h1 className="mb-3 text-2xl font-extrabold tracking-normal text-blue-gray-900">
                            Tìm văn bản pháp luật
                        </h1>
                        <div className="flex justify-center mb-4 align-middle">
                            <Input />
                        </div>
                        <h1 className="mb-2 text-2xl font-extrabold tracking-normal text-blue-gray-900">Chức Năng</h1>
                    </div>
                </div>
                <div className="row-span-5 gap-4">
                    <div className="grid grid-cols-4 gap-4">
                        {NavigatorCardData.map((item) => (
                            <NavigatorCard key={item.index} item={item} />
                        ))}
                    </div>
                </div>
            </Container>
        </main>
    );
}

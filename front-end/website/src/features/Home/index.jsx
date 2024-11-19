import React, { useEffect, useState } from "react";
import Paper from "@mui/material/Paper";
import { Container } from "@mui/material";
import Divider from "@mui/material/Divider";
import InputBase from "@mui/material/InputBase";
import IconButton from "@mui/material/IconButton";
import NavigatorCard from "./components/NavigatorCard.jsx";
import { NavigatorCardData } from "../../mock/Home.data.js";
import { MagnifyingGlassIcon } from "@heroicons/react/20/solid";
import NewsletterForm from "./components/NewsletterForm.jsx";
import News from "./components/News.jsx";

const Input = () => {
    return (
        <Paper component="form" className="px-[2px] py-1 flex items-center w-[300px] md:w-[400px]">
            <InputBase
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
export default function Home() {
    return (
        <main className="px-20">
            <div className="flex items-center justify-center mt-10">
                <div className="text-center">
                    <h1 className="mb-4 text-2xl font-extrabold tracking-normal text-blue-gray-900">
                        Tìm văn bản pháp luật
                    </h1>
                    <div className="grid grid-cols-1 gap-4 mb-20 md:grid-cols-5">
                        {NavigatorCardData.map((item) => (
                            <NavigatorCard key={item.index} item={item} />
                        ))}
                    </div>
                </div>
            </div>
            <News />
            <NewsletterForm />
        </main>
    );
}

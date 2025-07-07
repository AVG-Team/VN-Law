import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
    plugins: [react()],
    define: {
        global: "window",
    },
    resolve: {
        alias: {
            "~": "/src",
        },
    },
    server: {
        host: "0.0.0.0", // Cho phép truy cập từ các thiết bị khác
        port: 5173,
        strictPort: true,
    },
    envPrefix: "VITE_",
});

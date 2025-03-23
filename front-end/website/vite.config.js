import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [react()],
    resolve: {
        alias: {
            "~": "/src",
        },
    },
    server: {
        host: "0.0.0.0", // Cho phép truy cập từ các thiết bị khác
        port: 3000,
        strictPort: true,
    },
    envPrefix: "VITE_",
});

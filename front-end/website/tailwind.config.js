const tailwindTypo = require("@tailwindcss/typography");
const lineClamp = require("@tailwindcss/line-clamp");

/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./src/**/*.{js,jsx,ts,tsx}"],
    theme: {
        extend: {
            colors: {
                "blue-gray": {
                    50: "#6699cc",
                    100: "#578fc7",
                    200: "#4985c2",
                    300: "#3e7cb9",
                    400: "#3972ab",
                    500: "#34689c",
                    600: "#2f5e8d",
                    700: "#2d547f",
                    800: "#254b70",
                    900: "#204161",
                    950: "#1b3752",
                },
            },
            zIndex: {
                999999: '999999',
                99999: '99999',
                9999: '9999',
                999: '999',
                99: '99',
                9: '9',
                1: '1',
            },
        },
    },
    plugins: [tailwindTypo, lineClamp],
};

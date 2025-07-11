import * as React from "react";
import { LocalizationContext, ThemeContext, Viewer } from "@react-pdf-viewer/core";
import { toolbarPlugin } from "@react-pdf-viewer/toolbar";

import "@react-pdf-viewer/core/lib/styles/index.css";
import "@react-pdf-viewer/toolbar/lib/styles/index.css";

import vi_VN from "~/mock/VBQPPL/react_pdf_viewer_vi_VN.json";

const Localization = ({ item }) => {
    const toolbarPluginInstance = toolbarPlugin();
    const { Toolbar } = toolbarPluginInstance;

    const [currentTheme, setCurrentTheme] = React.useState("light");
    const [l10n, setL10n] = React.useState(vi_VN);

    const localizationContext = { l10n, setL10n };
    const themeContext = { currentTheme, setCurrentTheme };

    return (
        <ThemeContext.Provider value={themeContext} className="flex justify-center">
            <LocalizationContext.Provider value={localizationContext}>
                <div
                    className={`rpv-core__viewer rpv-core__viewer--${currentTheme}  w-full h-[950px] flex flex-col border border-[#0000004d]`}
                >
                    <div
                        style={{
                            alignItems: "center",
                            backgroundColor: currentTheme === "dark" ? "#292929" : "#eeeeee",
                            borderBottom: currentTheme === "dark" ? "1px solid #000" : "1px solid rgba(0, 0, 0, 0.1)",
                            display: "flex",
                            padding: ".25rem",
                        }}
                    >
                        <Toolbar />
                    </div>
                    <div className="justify-center flex-1 overflow-auto">
                        <div className="mx-3" dangerouslySetInnerHTML={{ __html: item }}></div>
                    </div>
                </div>
            </LocalizationContext.Provider>
        </ThemeContext.Provider>
    );
};

export default Localization;

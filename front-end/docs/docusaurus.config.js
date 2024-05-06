// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import { themes as prismThemes } from "prism-react-renderer";

/** @type {import('@docusaurus/types').Config} */
const config = {
    title: "VN LAW", // Title for your website.
    tagline: "Tri thức pháp luật Việt Nam", // Tagline for your website.
    favicon: "img/favicon.ico",

    // Set the production url of your site here
    url: "https://your-docusaurus-site.example.com",
    // Set the /<baseUrl>/ pathname under which your site is served
    // For GitHub pages deployment, it is often '/<projectName>/'
    baseUrl: "/",

    // GitHub pages deployment config.
    // If you aren't using GitHub pages, you don't need these.
    organizationName: "AVG-Team", // Usually your GitHub org/user name.
    projectName: "VN-Law", // Usually your repo name.

    onBrokenLinks: "throw",
    onBrokenMarkdownLinks: "warn",

    // Even if you don't use internationalization, you can use this field to set
    // useful metadata like html lang. For example, if your site is Chinese, you
    // may want to replace "en" with "zh-Hans".
    i18n: {
        defaultLocale: "en",
        locales: ["en"],
    },

    presets: [
        [
            "classic",
            /** @type {import('@docusaurus/preset-classic').Options} */
            ({
                docs: {
                    sidebarPath: "./sidebars.js",
                    // Please change this to your repo.
                    // Remove this to remove the "edit this page" links.
                    editUrl: "https://github.com/AVG-Team/VN-Law/tree/main/front-end/docs",
                    showLastUpdateAuthor: true,
                    showLastUpdateTime: true,
                },
                theme: {
                    customCss: "./src/css/custom.css",
                },
            }),
        ],
    ],

    themeConfig:
        /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
        ({
            // Replace with your project's social card
            image: "img/docusaurus-social-card.jpg",
            navbar: {
                title: "VN Law",
                logo: {
                    alt: "VN Law Logo",
                    src: "img/logo.svg",
                },
                items: [
                    {
                        type: "docSidebar",
                        sidebarId: "tutorialSidebar",
                        position: "left",
                        label: "Documentation",
                    },
                    { href: "https://www.olp.vn/", label: "Website", position: "left" },
                    {
                        href: "https://github.com/AVG-Team/VN-Law",
                        className: "header-github-link",
                        "aria-label": "GitHub repository",
                        position: "right",
                    },
                ],
            },
            footer: {
                style: "dark",
                links: [
                    {
                        title: "Organization",
                        items: [
                            {
                                label: "ICPC Vietnam",
                                href: "https://www.olp.vn/",
                            },
                            {
                                label: "Vfossa",
                                href: "https://vfossa.vn/",
                            },
                        ],
                    },
                    {
                        title: "References",
                        items: [
                            {
                                label: "Langchain",
                                href: "https://js.langchain.com/",
                            },
                            {
                                label: "Open AI",
                                href: "https://openai.com/",
                            },
                            {
                                label: "Weaviate",
                                href: "https://weaviate.io/",
                            },
                        ],
                    },
                    {
                        title: "More",
                        items: [
                            {
                                label: "About the Contest",
                                href: "https://vfossa.vn/topic/olympic-tin-hoc-sinh-vien-viet-nam-lan-thu-32/",
                            },
                            {
                                label: "OLP - HUSC",
                                href: "http://olp.husc.edu.vn",
                            },
                            {
                                label: "Hutech University",
                                href: "https://www.hutech.edu.vn",
                            },
                        ],
                    },
                ],
                copyright: `Copyright © ${new Date().getFullYear()} Hutech. All rights reserved`,
                logo: {
                    alt: "School Logo",
                    src: "img/school.png",
                    href: "https://www.hutech.edu.vn/",
                    width: 300,
                },
            },
            prism: {
                theme: prismThemes.github,
                darkTheme: prismThemes.dracula,
            },
        }),
};

export default config;

import React from "react";
import Link from "@docusaurus/Link";
import styles from "./style.module.css";
import SectionLayout from "../SectionLayout";

const TechList = [
    {
        url: "https://react.dev/",
        logo: require("../../../static/img/react.jpg").default,
    },
    {
        url: "https://spring.io/projects/spring-boot/",
        logo: require("../../../static/img/spring.png").default,
    },
    {
        url: "https://js.langchain.com/",
        logo: require("../../../static/img/langchain.png").default,
    },
    {
        url: "https://openai.com/",
        logo: require("../../../static/img/openai.png").default,
    },
];

const TechSection = () => {
    return (
        <SectionLayout
            title="Powered by"
            style={{ backgroundColor: "white", padding: "50px" }}
            titleStyle={{ color: "#444950" }}
        >
            <div
                className="row"
                style={{
                    justifyContent: "center",
                    gap: "5px",
                }}
            >
                {TechList.map(({ url, logo }, idx) => (
                    <div className="col col--2" key={url}>
                        <div className="col-demo text--center">
                            <div className={styles.colDemoItems}>
                                <Link href={url}>
                                    <img loading="lazy" src={logo} style={{ width: "100px" }} alt={`Tech ${idx}`} />
                                </Link>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </SectionLayout>
    );
};

export default TechSection;

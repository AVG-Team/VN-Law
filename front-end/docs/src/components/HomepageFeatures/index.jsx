import clsx from "clsx";
import Heading from "@theme/Heading";
import styles from "./styles.module.css";
import Lottie from "lottie-react";
import ChatBot from "@site/static/lottie/chatbot-lottie.json";
import Data from "@site/static/lottie/data.json";
import LLM from "@site/static/lottie/llm.json";

const FeatureList = [
    {
        title: "Chatbot Công Khai ",
        animationData: ChatBot,
        description: <> Đây là một bot trò chuyện công khai giúp người dân có được thông tin về chính phủ. </>,
    },
    {
        title: "Dữ liệu Chính Phủ",
        animationData: Data,
        description: (
            <>
                Chat bot được cung cấp bởi dữ liệu của chính phủ và được cập nhật thường xuyên để đảm bảo tính chính xác
                của thông tin.
            </>
        ),
    },
    {
        title: "Mô Hình Ngôn Ngữ Lớn",
        animationData: LLM,
        description: (
            <>
                Một mô hình ngôn ngữ lớn được sử dụng để đảm bảo bot trò chuyện có thể hiểu ý định của người dùng và
                cung cấp thông tin chính xác.
            </>
        ),
    },
];

function Feature({ animationData, title, description }) {
    return (
        <div className={clsx("col col--4")}>
            <div className={styles.featureDiv}>
                <Lottie className={styles.featureLottie} animationData={animationData} />
            </div>
            <div className="text--center padding-horiz--md">
                <Heading as="h3">{title}</Heading>
                <p>{description}</p>
            </div>
        </div>
    );
}

export default function HomepageFeatures() {
    return (
        <section className={styles.features}>
            <div className="container">
                <div className="row">
                    {FeatureList.map((props, idx) => (
                        <Feature key={idx} {...props} />
                    ))}
                </div>
            </div>
        </section>
    );
}

import React from "react";
import Link from "@docusaurus/Link";

import styles from "./styles.module.css";

const WhatIs = () => (
    <div className={styles.Boulder}>
        <section className={styles.whatIs}>
            <h1 className={styles["whatIs--title"]}>VN Law là gì ?</h1>
            <p className={styles["whatIs--p"]}>
                VN law là giải pháp chatbot cải tiến giúp quản lý và hợp lý hóa một cách thông minh quy trình giải quyết
                các thủ tục hành chính đa dạng. Được hỗ trợ bởi các mô hình ngôn ngữ tiên tiến, chatbot đảm bảo điều
                hướng trơn tru thông qua các tác vụ phức tạp, đảm bảo trải nghiệm trực quan và thân thiện với người dùng
                cho tất cả người dùng.
            </p>
            <Link to={"https://github.com/AVG-Team/VN-Law"} className="link-primary">
                Khám phá Github
            </Link>
        </section>
    </div>
);

export default WhatIs;

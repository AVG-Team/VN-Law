import React from "react";
import clsx from "clsx";
import styles from "../styles/index.module.css";
import Logo from "../../../assets/images/logo/logo2.png";

export default function Banner() {
    return (
        <header className={clsx("hero hero--primary", styles.heroBanner)}>
            <div className="container ">
                <img
                    loading="lazy"
                    width="250px"
                    height="250px"
                    alt="government chatbot logo"
                    className={styles.heroLogo}
                    src={Logo}
                />
                <h1 className="mb-1 text-2xl font-semibold text-blue-gray-900">VN LAW</h1>
                <p className="mb-1 text-xl font-medium text-blue-gray-900">Develope by AVG-TEAM</p>
            </div>
        </header>
    );
}

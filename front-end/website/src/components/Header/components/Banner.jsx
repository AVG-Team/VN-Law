import clsx from "clsx";
import React from "react";
import { ReactTyped } from "react-typed";
import { Container } from "@mui/material";
import styles from "../styles/index.module.css";
import Logo from "../../../assets/images/logo/logo-circle.png";

export default function Banner() {
    return (
        <main className={clsx("hero hero--primary", styles.heroBanner)}>
            <Container>
                <div className="flex justify-center mb-10">
                    <img
                        loading="lazy"
                        width="250px"
                        height="250px"
                        alt="government chatbot logo"
                        className={styles.heroLogo}
                        src={Logo}
                    />
                </div>
                <div className="flex justify-center">
                    <ReactTyped
                        strings={["Tri Thức Pháp Luật Việt Nam"]}
                        typeSpeed={100}
                        backSpeed={100}
                        backDelay={5000}
                        loop
                        className="mb-2 text-3xl font-semibold text-center text-blue-gray-950"
                    />
                </div>
                <p className="mb-2 text-lg font-normal text-blue-gray-950">Phát Triển Bởi AVG Team</p>
            </Container>
        </main>
    );
}

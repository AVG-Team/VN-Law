import React, { memo, useState } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import { Button, TextField } from "@mui/material";

const NewsletterSection = memo(
    ({
        title = "Đăng ký nhận tin",
        description = "Đăng ký để nhận những tin tức mới nhất về pháp luật và chính sách",
        className = "",
        delay = 0.2,
    }) => {
        const [email, setEmail] = useState("");

        const handleSubmit = (e) => {
            e.preventDefault();
            // Handle newsletter subscription
            console.log("Subscribing with email:", email);
            setEmail("");
        };

        return (
            <motion.section
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5 }}
                className={`py-16 md:py-24 bg-blue-50 ${className}`}
            >
                <div className="container px-4 mx-auto">
                    <motion.div
                        initial={{ y: 20, opacity: 0 }}
                        whileInView={{ y: 0, opacity: 1 }}
                        viewport={{ once: true }}
                        transition={{ duration: 0.5, delay }}
                        className="max-w-3xl mx-auto text-center"
                    >
                        <motion.h2
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: delay + 0.1 }}
                            className="mb-4 text-3xl font-bold text-gray-900 md:text-4xl"
                        >
                            {title}
                        </motion.h2>

                        <motion.p
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: delay + 0.2 }}
                            className="mb-8 text-lg text-gray-600"
                        >
                            {description}
                        </motion.p>

                        <motion.form
                            initial={{ y: 20, opacity: 0 }}
                            whileInView={{ y: 0, opacity: 1 }}
                            viewport={{ once: true }}
                            transition={{ duration: 0.5, delay: delay + 0.3 }}
                            onSubmit={handleSubmit}
                            className="flex flex-col gap-4 md:flex-row md:gap-2"
                        >
                            <TextField
                                type="email"
                                placeholder="Nhập email của bạn"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                required
                                className="flex-1"
                            />
                            <Button
                                type="submit"
                                variant="contained"
                                className="!bg-blue-600 hover:!bg-blue-700 !text-white !px-8 !py-2"
                            >
                                Đăng ký
                            </Button>
                        </motion.form>
                    </motion.div>
                </div>
            </motion.section>
        );
    },
);

NewsletterSection.propTypes = {
    title: PropTypes.string,
    description: PropTypes.string,
    className: PropTypes.string,
    delay: PropTypes.number,
};

NewsletterSection.displayName = "NewsletterSection";

export default NewsletterSection;

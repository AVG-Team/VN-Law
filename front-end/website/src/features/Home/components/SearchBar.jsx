import React, { memo, useState } from "react";
import PropTypes from "prop-types";
import { motion } from "framer-motion";
import { Paper, InputBase, IconButton } from "@mui/material";
import { Search } from "@mui/icons-material";

const SearchBar = memo(({ placeholder = "Nhập từ khóa tìm kiếm...", onSearch, className = "", delay = 0.2 }) => {
    const [searchQuery, setSearchQuery] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();
        if (onSearch) {
            onSearch(searchQuery);
        }
    };

    return (
        <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay }}
        >
            <form onSubmit={handleSubmit}>
                <Paper
                    component="div"
                    className={`flex items-center w-full max-w-2xl mx-auto shadow-lg hover:shadow-xl transition-shadow duration-300 ${className}`}
                >
                    <InputBase
                        className="flex-1 px-6 py-4 text-lg"
                        placeholder={placeholder}
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        inputProps={{ "aria-label": "search" }}
                    />
                    <IconButton type="submit" className="!p-4 !mr-2" aria-label="search">
                        <Search className="!text-2xl !text-blue-600" />
                    </IconButton>
                </Paper>
            </form>
        </motion.div>
    );
});

SearchBar.propTypes = {
    placeholder: PropTypes.string,
    onSearch: PropTypes.func,
    className: PropTypes.string,
    delay: PropTypes.number,
};

SearchBar.displayName = "SearchBar";

export default SearchBar;

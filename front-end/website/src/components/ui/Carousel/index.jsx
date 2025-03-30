import React, { useState } from "react";
import PropTypes from "prop-types";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChevronLeft, faChevronRight } from "@fortawesome/free-solid-svg-icons";

const Item = ({ image, title }) => {
    return (
        <div className="flex flex-col items-center justify-center w-48">
            <div className="flex items-center justify-center w-48 h-48 bg-white rounded-lg">
                <img className="object-cover w-40 h-40 rounded-xl" src={image} alt={title} />
            </div>
            <p className="mt-2 text-lg font-bold text-center h-14 line-clamp-2 hover:line-clamp-none">{title}</p>
        </div>
    );
};

Item.propTypes = {
    image: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
};

Carousel.propTypes = {
    items: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.number.isRequired,
            imagePath: PropTypes.string.isRequired,
            title: PropTypes.string.isRequired,
        }),
    ).isRequired,
};

export default function Carousel({ items }) {
    const [startIndex, setStartIndex] = useState(0);

    const nextSlide = () => {
        setStartIndex((prevIndex) => (prevIndex + 1) % items.length);
    };

    const prevSlide = () => {
        setStartIndex((prevIndex) => (prevIndex - 1 + items.length) % items.length);
    };

    const visibleItems = [...items.slice(startIndex), ...items.slice(0, startIndex)].slice(0, 6);

    return (
        <div className="container relative w-full mx-auto">
            <div className="flex flex-row items-center justify-center w-full gap-4 py-10 overflow-hidden ">
                {visibleItems.map((item, index) => (
                    <Item key={index} image={item.imagePath} title={item.title} price={item.price} />
                ))}
            </div>
            <a
                href="/san-pham"
                className="absolute top-0 w-20 h-10 p-2 text-lg transition-all transform -translate-y-1/2 right-36 hover:bg-opacity-75 text-Light-Apricot-600 hover:text-Light-Apricot-300 whitespace-nowrap"
            >
                Xem thêm
            </a>
            <button
                onClick={prevSlide}
                className="absolute top-0 w-10 h-10 p-2 transition-all transform -translate-y-1/2 rounded-full bg-Coral-Pink-500 right-24 hover:bg-opacity-75"
            >
                <FontAwesomeIcon icon={faChevronLeft} className="w-6 h-6 text-white" />
            </button>
            <button
                onClick={nextSlide}
                className="absolute top-0 w-10 h-10 p-2 transition-all transform -translate-y-1/2 rounded-full bg-Coral-Pink-500 right-10 hover:bg-opacity-75"
            >
                <FontAwesomeIcon icon={faChevronRight} className="w-6 h-6 text-white" />
            </button>
            <div className="absolute flex flex-row w-full gap-2 transform -translate-x-1/2 bottom-2 left-[97%]">
                {items.map((item) => (
                    <div
                        key={item.id}
                        onClick={() => setStartIndex(items.indexOf(item))}
                        className={`w-2 h-2 rounded-full cursor-pointer ${
                            items.indexOf(item) === startIndex ? "bg-Coral-Pink-500" : "bg-gray-300"
                        }`}
                    />
                ))}
            </div>
        </div>
    );
}

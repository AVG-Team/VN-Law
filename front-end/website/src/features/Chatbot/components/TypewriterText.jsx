import React, { useState, useEffect } from "react";

const TypewriterText = ({ text, pendingReplyServer, setPendingReplyServer }) => {
    const [displayedText, setDisplayedText] = useState("");
    console.log(text);
    useEffect(() => {
        let charIndex = 0;
        const interval = setInterval(() => {
            if (charIndex <= text.length) {
                setDisplayedText(text.substring(0, charIndex));
                charIndex++;
            } else {
                clearInterval(interval);
                setPendingReplyServer(false);
            }
        }, 25);

        return () => clearInterval(interval);
    }, [text, setPendingReplyServer]);

    return <p className="text-black text-lg">{displayedText}</p>;
};

export default TypewriterText;

import React, {useEffect, useState} from "react";

const TypewriterText = ({text, pendingReplyServer, setPendingReplyServer}) => {
    const [displayedText, setDisplayedText] = useState("");
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
        }, 5);

        return () => clearInterval(interval);
    }, [text, setPendingReplyServer]);

        const formatLinks = (text) => {
            const urlPattern = /(\bhttps?:\/\/[^\s]+)/g;
            return text.split('\n').map((line, index) => (
                <React.Fragment key={index}>
                    {line.split(urlPattern).map((part, i) => (
                        urlPattern.test(part) ? <a key={i} href={part} target="_blank" rel="noopener noreferrer"
                                                   style={{color: 'blue'}}>{part}</a> : part
                    ))}
                    <br/>
                </React.Fragment>
            ));
        };
    const formattedText = formatLinks(displayedText);

    return <p className="text-black text-lg">{formattedText}</p>;
};

export default TypewriterText;

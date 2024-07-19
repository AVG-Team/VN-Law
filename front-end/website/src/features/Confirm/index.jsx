import React, { useEffect, useState } from "react";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import Logo from "../../assets/images/logo/logo-circle.png";
import {getCurrentUser} from "../../api/auth-service/authClient";
import { toast } from "react-toastify";
import {useNavigate} from "react-router-dom";
// import {setToken} from "../../../services/apis/auth.js";

export default function Notify(props) {

    const navigate = useNavigate();
    const [token, setToken] = useState("");

    // eslint-disable-next-line react/prop-types
    const title = props.title;
    useEffect(() => {
        document.title = title ? `${title}` : "Trang không tồn tại";

        const urlParams = new URLSearchParams(window.location.search);
        setToken(urlParams.get('token'));
    }, [title]);

    useEffect(() => {
        if(token)
            handleCheckVerify().then();
    }, [token]);

    const handleCheckVerify = async() => {
        try {
            const response = await getCurrentUser({
                token: token,
            });
            let message = response.message;
            toast.success(message, {
                onClose: () => navigate('/'),
                autoClose: 2000,
                buttonClose: false
            });
        } catch (err) {
            toast.error(err.message);
            console.error("Error fetching server: ", err);
        }
    }

    return <>
        <div className="min-h-full grid lg:gap-4">
            <DotLottieReact src="https://lottie.host/59f5e53d-ce7c-4d60-aaa9-7ba750fc86a8/OhazetStzz.json"
                            loop autoplay direction="1" />
        </div>
    </>;
}
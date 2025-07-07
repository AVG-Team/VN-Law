// ActivateAccountButton.jsx
import React, { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import axios from "axios";
import { toast } from "react-toastify";

export default function ActivateAccountButton() {
    const [searchParams] = useSearchParams();
    const [verificationCode, setVerificationCode] = useState("");

    useEffect(() => {
        const code = searchParams.get("verificationCode");
        if (code) {
            setVerificationCode(code);
        }
    }, [searchParams]);

    useEffect(() => {
        const activateAccount = async () => {
            if (verificationCode) {
                try {
                    const response = await axios.get(
                        `http://14.225.218.42:9000/api/auth/confirm?verificationCode=${verificationCode}`,
                    );
                    toast.success(response.data);
                } catch (err) {
                    toast.error(err.response.data);
                }
            }
        };

        activateAccount();
    }, [verificationCode]);

    return null;
}

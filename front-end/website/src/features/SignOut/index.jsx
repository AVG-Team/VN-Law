import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { StorageKeys } from '../../../services/key/keys.js';
import Cookies from "js-cookie";

export default function SignOut() {
    const navigate = useNavigate();

    useEffect(() => {
        Cookies.remove(StorageKeys.ACCESS_TOKEN);
        navigate('/');
    }, [navigate]);

    return (
        <div>
            <p>Đăng xuất</p>
        </div>
    );
};

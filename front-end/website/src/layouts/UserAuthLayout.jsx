import React from 'react';
import Cookies from 'js-cookie';
import { Outlet } from 'react-router-dom';
import { Navigate } from 'react-router-dom';
import { StorageKeys } from '~/common/constants/keys.js';

export default function UserAuthLayout() {
    if (Cookies.get(StorageKeys.ACCESS_TOKEN)) {
        return <Navigate to="/" replace />;
    }

    return (
        <div className="userauth-layout">
            <div className="content">
                <Outlet />
            </div>
        </div>
    );
};
import { ACCESS_TOKEN, API_BASE_URL } from "../common/constants";

const request = (options) => {
    const headers = new Headers({
        'Content-Type': 'application/json'
    });

    if(localStorage.getItem(ACCESS_TOKEN)){
        headers.append('Authorization','Bearer ' + localStorage.getItem(ACCESS_TOKEN));
    }

    const defaults = {headers: headers};
    options = Object.assign({}, defaults, options);

    return fetch(options.url, options)
    .then(response =>
        response.json().then(json => {
            if (!response.ok) {
                return Promise.reject(json);
            }
            return json;
        })
    );
};

export function authenticate(authenticateRequest){
    retur request({
        url: API_BASE_URL + "/auth/authenticate",
        method: 'POST',
        body: JSON.stringify(authenticateRequest)
    })
}

export function register(registerRequest){
    return request({
        url: API_BASE_URL + "/auth/register",
        method: 'POST',
        body: JSON.stringify(registerRequest)
    })
}

export function entryPoint(entryPointRequest){
    return request({
        url: API_BASE_URL + "/demo-controller",
        method: 'GET',
        body: JSON.stringify(entryPointRequest)
    })
}


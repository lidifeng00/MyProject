import axios from "axios";


//set request of use
axios.interceptors.request.use(config =>{
    const passURL = ['/signin', '/signup'];
    if(passURL.includes(config.url))
        return config;
    const tk = localStorage.getItem('@#@TOKEN');
    if(tk){
        config.headers.Authorization = 'Bearer ' +tk;
    }else{
        delete  config.headers.Authorization;
    }
    return config;
})


axios.interceptors.response.use( response=>{
    const {status, msg} =response.data;
    if(status ===1  && msg === 'TOKEN ERROR'){
        window.location.href ='/signin';
        localStorage.removeItem('@#@TOKEN');
    }
    return response;
})

export default axios;
import axios from "./request";


export default function ajax(url, data={},type='GET'){
    //get paramStr : email&password
    //data:{email: , password: }
    if(type === 'GET'){
        let paramStr ='';
        Object.keys(data).forEach(key =>{
            paramStr += key + '=' +data[key] +'&'
        })
        if(paramStr) {
            paramStr.substring(0, paramStr.length-1)
        }
        return axios.get(url+'?'+paramStr)
    }else{
        return axios.post(url,data)
    }

}
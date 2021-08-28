import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import decode from 'jwt-decode'
import store from "./redux/store";
import cookie from 'react-cookies';
import {Provider} from "react-redux";
import {syncInfoAc} from "./redux/actions";

const tk =localStorage.getItem('@#@TOKEN')
if(tk) {
  try{
  store.dispatch( syncInfoAc(decode(tk)));
} catch (err){
  localStorage.removeItem('@#@TOKEN');
  for (var i = 1; i <= parseInt(cookie.load('orderNum')); i++) {
      cookie.remove('order' + i);
  }
  cookie.remove('orderNum');
  cookie.remove('drinkNum');
  alert('Login timeout, please login again');
  window.location.href ='/signin';
  }

}

ReactDOM.render(
    <Provider store={store}>
  <React.StrictMode>
    <App />
  </React.StrictMode>
    </Provider>
,
  document.getElementById('root')
);


// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals

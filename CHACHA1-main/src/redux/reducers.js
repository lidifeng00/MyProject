import {combineReducers} from "redux";
import isEmpty from 'lodash/isEmpty'
import {
    AUTH_SUCCESS,
    ERROR_MSG,
    REGISTER_SUCCESS,
    ERROR_MSG_REGISTER,
    SYNC_STATE_INFO,
    FETCH_USER_DATA
} from "./action-types";
import swal from 'sweetalert';

const initUser ={
    isAuth: false,
    email: '',
    msg: '',
    username:'',
    redirectTo: '',
}

function user(state=initUser, action){
    switch (action.type) {
        case AUTH_SUCCESS:

            return {isAuth: !isEmpty(action.data),
                    ...action.data,
                    redirectTo: '/' }
        case ERROR_MSG:
            return {...state, msg: action.data}
        default:
            return state
    }
}
function userregister(state=initUser, action){
    switch (action.type) {
        case REGISTER_SUCCESS:
            swal("Welcome to CHA-CHA!", "Your account has been created successfully.", "success");
            return {...action.data, redirectTo: '/signin',msg: '' }
        case ERROR_MSG_REGISTER:
            return {...state, msg: action.data}
        default:
            return state
    }
}
const loginUser ={
    isAuth: false,
    user:{}
}

function syncInfoAc(state =loginUser,action){
    switch (action.type) {
        case SYNC_STATE_INFO:
            return {isAuth: !isEmpty(action.data),
                    user:action.data}
        default:
            return state
    }
}

const initUserData = {
  userData: {}
}

function fetchUserData(state=initUserData, action){
  switch (action.type) {
      case FETCH_USER_DATA:
          return {userData: action.data}
      default:
          return state
  }
}

export default combineReducers({
    syncInfo: syncInfoAc,
    userreducer: user,
    registerreducer: userregister,
    fetchreducer: fetchUserData
})
import React from "react";
import {connect} from "react-redux";

export default function (Comp){
     class Auth extends React.Component {
        // if not register, turn to login
        componentWillMount() {
            if(this.props.loginData.isAuth === false){
                this.props.history.push ('/');
            }else{
            }
        }
        componentWillUpdate(nextProps, nextState, nextContext) {
            if(!nextProps.loginData.isAuth && nextProps.loginData.isAuth !== this.props.loginData.isAuth){
                this.props.history.push ('/');
            }
        }

        render() {
            return <Comp {...this.props}/>
        }
    }
    return connect(
        state=>({loginData : state.syncInfo}),
        {}
        )(Auth);
}


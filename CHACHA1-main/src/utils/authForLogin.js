import React from "react";
import {connect} from "react-redux";

export default function (Comp){
    class AuthForLogin extends React.Component{
        componentWillMount() {
            if(this.props.loginData.isAuth === true){
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
    )(AuthForLogin)
}
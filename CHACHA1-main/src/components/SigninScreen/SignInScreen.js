import React, {Component} from "react";
import img1URL from './img/img_signin.png'
import img2URL from './img/img_signin02.png'
import imglogo from './img/logo.jpg'
import {Link, Redirect} from "react-router-dom";
import "./Signin.css"
import {connect} from "react-redux";
import {login} from "../../redux/actions";
import showlogo from './img/show.png'
import hidelogo from './img/hide.png'


class SignInScreen extends Component {

    constructor(props) {
        super(props);
        this.state ={
            email: "",
            password: "",
            emaildisplay: false,
            passworddisplay: false,
            shown: false,
        };}

        getEmail(e) {
            const{value} = e.target;
            const reg = /([\w]+)@([\w]+)\.(\w+)/;
            if(reg.test(value) || value===""){
            this.setState({
                email: e.target.value,
                emaildisplay: false
            });}else{
                this.setState({
                    emaildisplay: true})
            }
        }
        getPassword(e) {
            const {value} =e.target;
            if(value.length <12 || value === ''){
                this.setState({
                    password: e.target.value,
                    passworddisplay: false
                })
            }else{
                this.setState({
                    passworddisplay: true})
            }
        }
        onesubmitbutton= (e)=>{
            this.props.login(this.state)
        }

        setShow () {
            this.setState({
                shown:! this.state.shown
            })
        }
    

    render() {
        const{msg, redirectTo} =this.props.user
        if(redirectTo){
           return <Redirect to={redirectTo}/>
        }
        return(
            <div>
                <section>
            <div className="body_signin_container">
                <div className="body_signin_Bx">
                    <div className='body_user'>
                    <div className="imgBx"><img src={imglogo} alt=''/> </div>
                    <div className="container_form_signIn">
                        <form action="#" className="form_signIn" id="form_for_signIn">
                            <h2>Sign In</h2>
                            {msg?<div className='error-msg'>{msg}</div>:null}
                            <div className="form_signin_email">
                                <img src={img1URL} alt=''/>
                                <input type="email" placeholder="Enter Email" className= "signIn_input" onChange={this.getEmail.bind(this)}/>
                            </div>
                            <div className= {this.state.emaildisplay?"errorMsgEmailtrue":"errorMsgEmailfalse"}>
                                <span>Invalid Email. Please enter again</span>
                            </div>
                        <div className="form_signin_email">
                            <img src={img2URL} alt=''/>
                            <input type={this.state.shown ? 'text' : 'password'} placeholder="Enter PassWord" className= "signIn_input" onChange={this.getPassword.bind(this)}/>
                            <button className='password-button' type='button' onClick={this.setShow.bind(this)}><img src={this.state.shown ?hidelogo: showlogo} alt=''/></button>
                        </div>
                            <div className= {this.state.passworddisplay?"errorMsgEmailtrue":"errorMsgEmailfalse"}>
                                <span>The Password field can not exceed 12 characters in length.</span>
                            </div>
                        <div className="form_checkbox">
                            <p><input type="checkbox" className="custom-control-input" id="check1"/>Remember Password</p>
                        </div>
                            <button type='button' onClick={this.onesubmitbutton}>Login</button>

                            <div className='form_createaccount'>
                                <label/>
                                <div>
                                    New Customer? { ' '}
                                    <Link to='/signup' >Create Your Account</Link>
                                </div>
                            </div>
                        </form>
                    </div>
                    </div>
            </div>
            </div>
                </section>

               
            </div>
        )
    }
}

export default connect(
    state => ({user: state.userreducer}),
    {login}
)(SignInScreen);
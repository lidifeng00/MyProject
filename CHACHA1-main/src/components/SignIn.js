import React from 'react';
import Button from 'react-bootstrap/Button';
import {connect} from "react-redux";
import {Link} from "react-router-dom";
import {logOut} from "../redux/actions";
import NavDropdown from "react-bootstrap/NavDropdown";
import cookie from 'react-cookies';


class SignIn extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      show: false,
      account:cookie.load('emailid')
    };
  }

  handleShow() {
    this.setState({
      show: true
    });
  }

  handleClose() {
    this.setState({
      show: false,
    });
  }

  onSubmit(e) {
    e.preventDefault();
    this.handleClose();
  }

  render() {
    return (
      <div >
        {this.props.loginData.isAuth?
            <div>
              <NavDropdown  title={this.props.loginData.user.username}>
                <NavDropdown.Item href="/user">My Profile</NavDropdown.Item>
                <NavDropdown.Item href='/user/member'>Member Management</NavDropdown.Item>
                <NavDropdown.Item href='/user/coupon'>Coupon</NavDropdown.Item>
                <NavDropdown.Item href="/user/order-history">Order History</NavDropdown.Item>
                <NavDropdown.Item href="/user/favorites">Favorites</NavDropdown.Item>
                <NavDropdown.Item href="/user/settings">Settings</NavDropdown.Item>
                <NavDropdown.Item href="/" onClick={this.props.logOut}>Logout</NavDropdown.Item>
              </NavDropdown>
            </div>
            :<Button className="btn-default" ><Link to='/signin' style={{ color: "#616161", textDecoration:'none'}}>SIGN IN</Link></Button>
        }
      </div>
    );
  }
}




export default connect(
    state=>({loginData : state.syncInfo}),
    {logOut}
)(SignIn);
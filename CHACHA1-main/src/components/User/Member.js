import React, {Component} from 'react';
import './Member.css'
import logo from './logo.jpg'
import vip from './vip.jpg'
import {connect} from "react-redux";
import {fetchData, logOut} from "../../redux/actions";
import Carousel from "react-bootstrap/Carousel";
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import {reqGetMembership} from "../../api";
import ReactDOM from 'react-dom'
import swal from 'sweetalert';

const PayPalButton = window.paypal.Buttons.driver("react", { React, ReactDOM });

class Member extends Component {

    constructor(props) {
        super(props);
        this.state = {
            open: false,
            password:'',
            memberdate: {},
            memeberday:false
        }
    }

    handleClickOpen = () => {
        this.setState({
            open: true
        })
    };

     handleClose = () => {
         this.setState({
             open: false
         })
    };
     handleEnter = async () => {
         this.setState({
             open: false
         })
         const data = {
             password: this.state.password,
             memberdate: new Date()
         };
         const response = await reqGetMembership(data).catch(error => {
              console.log(error.response)
          })
          const result =response.data
          swal(result.msg )
     }
    getPassword(e) {
        const {value} =e.target;
            this.setState({
                password: value,
            })
    }
    handleClickCheck = () => {
        this.setState({
            memberdate: new Date()
        })
    };

    createOrder(data, actions) {
        return actions.order.create({
            intent: "CAPTURE",
            purchase_units: [
                {
                    description: 'Renew CHA-CHA Membership',
                    amount: {
                        value: 10,
                    },
                },
            ],
        });
    }

    onApprove(data, actions) {
        swal({text:'You have been renewed your membership', icon:"success"})
        this.setState({
            memeberday: true
        })
        return actions.order.capture();
    }

    render() {
        const date= this.props.loginData.userData.memberdate;
        const datetime =Date.parse(date)
        const datetime2 =new Date(datetime)
        const result1 =datetime2.toUTCString()
        const result = this.state.memeberday?datetime2.setDate(datetime2.getDate()+60):
            datetime2.setDate(datetime2.getDate()+30)
        const result2 = new Date(result).toUTCString()
        return (
            <div>
                <div className='member'>
                <h1>Member Management</h1>
                <hr/>
                    <h3>Card Information</h3>
                    <div>
                            <p>{this.props.loginData.userData.isadmin?
                                <p style={{color:'blue'}}>{result1}<span style={{color:"black", fontWeight:"bold"}}> TO </span>{result2}</p>: 'Not a Member'} </p>
                    </div>
                    <div className='cardStyle'>
                        <div className='card-info'>
                            <span style={{paddingLeft: 10, marginTop:10, display:"inline-block"}}>Name  :   <span style={{fontWeight: 'bold',fontStyle:'unset'}}>{this.props.loginData.userData.username}</span> </span>
                            <br/>
                            <span style={{paddingLeft: 10, marginTop:5,display:"inline-block"}}>Card ID : {this.props.loginData.userData.isadmin?
                                <span style={{fontSize:10}}>{this.props.loginid.user.id}</span>
                                :<span>xxxxxxxxxxxxxxxxx</span>}</span>
                        </div>
                        <div className='card-logo'>
                            <img src={logo} style={{width:80, height:80}} alt='img'/>
                        </div>
                        <div className='card-button'>
                            <p>V I P</p>
                        </div>
                    </div>
                </div>

                <hr/>
                <div>
                    <h3>Membership privileges</h3>
                    <div className='member-privileges'>
                        <Carousel id="imageCarousel" className="carousel slide" data-bs-ride="carousel">
                            <Carousel.Item>
                                <img src={vip} className="d-block w-100" alt="privileges1" />
                            </Carousel.Item>
                            <Carousel.Item>
                                <img src={vip} className="d-block w-100" alt="privileges2" />
                            </Carousel.Item>
                            <Carousel.Item>
                                <img src={vip} className="d-block w-100" alt="privileges3" />
                            </Carousel.Item>
                            <Carousel.Item>
                                <img src={vip} className="d-block w-100" alt="privileges4" />
                            </Carousel.Item>
                        </Carousel>
                    </div>
                </div>
                <hr/>
                <div>
                    <div>
                        <p>Member points: </p>
                        <span>* Meet point exchange member </span>
                        <button onClick={this.handleClickCheck}> Exchange member</button>
                    </div>
                    <hr/>
                    <div>
                        <h3>Free MemberShip for New</h3>
                        <div>
                            <Button variant="outlined" color="default" onClick={this.handleClickOpen}>
                                Try Free Membership
                            </Button>
                            <Dialog open={this.state.open} onClose={this.handleClose} aria-labelledby="form-dialog-title">
                                <DialogTitle id="form-dialog-title">Subscribe</DialogTitle>
                                <DialogContent>
                                    <DialogContentText>
                                        Do you want to try 30 days free membership? Enter your Password
                                    </DialogContentText>
                                    <TextField
                                        autoFocus
                                        margin="dense"
                                        id="name"
                                        label="password"
                                        type="password"
                                        fullWidth
                                        onChange={this.getPassword.bind(this)}
                                    />
                                </DialogContent>
                                <DialogActions>
                                    <Button onClick={this.handleClose} color="default">
                                        Cancel
                                    </Button>
                                    <Button onClick={this.handleEnter} color="default">
                                        Try
                                    </Button>
                                </DialogActions>
                            </Dialog>
                        </div>
                        <hr/>
                        <h3> Want to Renew Membership? </h3>
                        <hr/>
                        <div className='paypal-button'>
                            <PayPalButton
                                createOrder={(data, actions) => this.createOrder(data, actions)}
                                onApprove={(data, actions) => this.onApprove(data, actions)}
                            />
                        </div>
                    </div>

                </div>
            </div>


        );
    }
}

export default connect(
    state=>({loginData : state.fetchreducer,
        loginid : state.syncInfo
    }),
    {fetchData,logOut}
)(Member);



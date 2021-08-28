import React, {Component} from 'react';
import './coupon.css'
import {connect} from "react-redux";
import {fetchData} from "../../redux/actions";
import {reqGetCoupon} from "../../api";
import swal from 'sweetalert';
class Coupon extends Component {

    constructor(props) {
        super(props);
        this.state = {
            coupons : [{
                _id: "",
                couponType: 0
            }]
        }
    }
    getCoupon = async () => {
        if (this.props.loginData.userData.isadmin) {
            const data ={
                isadmin: this.props.loginData.userData.isadmin
            }
            const response = await reqGetCoupon(data)
            const result =response.data
            swal({text: result.msg, icon:"success"})
        } else {
            swal({text: 'You are not member',icon: "warning"})
        }
    }
    componentDidMount(){
        const userData = this.props.loginData.userData;
        this.setState({coupons: userData.coupon});
    }

    formatOrderCards = () => {
        if(this.state.coupons){
            return this.state.coupons.map((coupon, index) => {
                  if (this.state.coupons[index].couponType === 1) {
                      return (
                          <div className='coupon'>
                              <div className='coupon_left'>
                                  <span>$ 2.00</span>
                                  <br/>
                                  <button>
                                      <a href='/order' style={{color:"black"}}>
                                          Use
                                      </a>
                                  </button>
                              </div>
                              <div className='coupon_right'>
                        <span>
                          Membership Coupon #1
                        </span>
                                  <br/>
                                  <span style={{color: 'white'}}>
                          $2 discount for consumption over $10
                        </span>
                              </div>
                          </div>
                      )
                  } else if (this.state.coupons[index].couponType === 2){
                      return (
                          <div className='coupon'>
                              <div className='coupon_left_type2'>
                                  <span>Free Drink</span>
                                  <br/>
                                  <button>
                                      <a href='/order' style={{color:"black"}}>
                                          Use
                                      </a>
                                  </button>
                              </div>
                              <div className='coupon_right_type2'>
                        <span>
                          Membership Coupon #2
                        </span>
                                  <br/>
                                  <span style={{color: 'white'}}>
                          Get Free Drink for 1
                        </span>
                              </div>
                              <br/>
                          </div>
                      )
                  }
            })
        }
    }

    render() {
        return (
            <div>
                <h1>Coupon</h1>
                <hr/>
                <button onClick={this.getCoupon}>Click me to get coupons</button>
                <hr/>
                {this.formatOrderCards()}
            </div>
        );
    }
}

export default connect(
    state=>({loginData : state.fetchreducer
    }),
    {fetchData}
)(Coupon);

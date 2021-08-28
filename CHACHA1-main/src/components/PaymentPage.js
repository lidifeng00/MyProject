import React from 'react';
import cookie from 'react-cookies';
import { connect } from "react-redux";
import { addorder } from "../redux/actions";
import ReactDOM from "react-dom";

const PayPalButton = window.paypal.Buttons.driver("react", { React, ReactDOM });
class PaymentPage extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      order: {
        timemillis: 0,
        subtotal: 0,
        discount: 0,
        memberDiscount: 0,
        price: 0,
        pickUp: true,
        location: "",
        usedCoupon: 0,
        products: [{
          name: "",
          size: "",
          price: 0,
          unitPrice: 0, //new
          ice: "",
          sweetness: "",
          extras: [],
          quantity: ""
        }]
      },
      profile: {
        firstname: "",
        lastname: "",
        phone: "",
        address: "",
      },
      coupon: [{
        couponType: 0,
        _id: ""
      }],
      processed: false
    }
    this.handleCouponSelected = this.handleCouponSelected.bind(this);
  }


  handleCouponSelected(event){
    let minPrice;
    if(event.target.value == 1)
      minPrice = 10; //
    else if(event.target.value == 2)
      minPrice = 0;
    // if(this.state.order.price < minPrice){

    // }else {
      this.state.order.usedCoupon = event.target.value;
      let usedCoupon = this.state.order.usedCoupon;
      let subtotal = this.state.order.subtotal;
      let products = this.state.order.products;
      let discount = this.discount(usedCoupon, products) + this.state.order.memberDiscount;
      let totalPrice = subtotal - discount;
      this.state.order.discount = discount;
      this.state.order.price = totalPrice;
      this.setState({order: this.state.order})
    // }
  }

  createOrder(data, actions) {
    return actions.order.create({
      intent: "CAPTURE",
      purchase_units: [
        {
          description: 'purchase',
          amount: {
            value: this.state.order.price,
          },
        },
      ],
    });
  }

  onApprove(data, actions) {
    this.props.addorder(this.state.order);
    for (var i = 1; i <= parseInt(cookie.load('orderNum')); i++) {
      cookie.remove('order' + i);
    }
    cookie.save('drinkNum', 0, { path: "/" });
    cookie.save('orderNum', 0, { path: "/" });
    this.setState({ processed: true });
  }
  componentDidMount() {
    const orderData = this.props.location.state.order;
    const userData = this.props.user.userData;
    const coupon = userData.coupon;
    if (orderData && userData.profile) {
      this.setState({ order: orderData });
      this.setState({ profile: userData.profile });
      this.setState({coupon: coupon});
      //this.state.order.subtotal = this.props.location.state.order.price;
      //this.setState({ order: this.state.order });
    }
  }

  discount(usedCoupon, products){
    var off;
    switch (usedCoupon){
      case "1":
        off = 2;
        return off;
      case "2":
        var min = products[0].unitPrice;
        for(var i=0; i<products.length; i++){
          if(products[i].price < min){
            min = products[i].unitPrice;
          }
        }
        return parseFloat(min);
      default:
        return 0;
    }
  }

  render() {
    console.log("this.props.user.userData");
    console.log(this.props.user.userData)
    console.log("this.state");
    console.log(this.state);

    const pickUp = this.state.order.pickUp;

    const listProducts = this.state.order.products.map((products) =>
      <div>
        <p className="inlineP">{products.name}, </p>
        <p className="geryP">{products.size} size, {products.ice}, {products.sweetness}, {products.extras}, x{products.quantity}</p>
      </div>
    );

    const listCoupons = this.state.coupon.map((coupon) =>
    {
      if(coupon.couponType == 1){
        if(this.state.order.subtotal >= 10) {
          return <option value="1">$2 Off (Over $10)</option>
        }else{
          return 0;
        }
      }else if(coupon.couponType == 2){
        if(parseInt(cookie.load('drinkNum')) > 1){
          return <option value="2">Get A Free Drink</option>
        }
      }
    })
    const street = this.state.order.location.split(',')[0];

    if (this.state.processed) {
      window.open("/confirmation", "_self");
    }

    return (
      <div className="container-confirm">
        <div className="card" id="LocationConfirm">
          <div className="card-body">
            {pickUp ? <h6>Pick-Up from</h6> : <h6>Delivery to</h6>}
            <h3>{street}</h3>
            <h6 className="greyP">{this.state.order.location} </h6>
          </div>
        </div>

        <div className="card" id="PickUpConfirm">
          <div className="card-body">
            {pickUp ? <h4>Pick-Up ASAP</h4> : <h4>Delivery Now</h4>}
            <hr className="solid"></hr>
            <h4 style={{display:"block"}}>Contact Information</h4>
            <p></p>
            <p style={{display:"block", float: "left", fontWeight:'bold'}}>{this.state.profile.firstname} {this.state.profile.lastname}, {this.state.profile.phone}</p>
          </div>
        </div>

        <div className="card" id="CouponConfirm">
          <div className="card-body">
            <h4>Choose Your Coupon</h4>
            <hr className="solid"></hr>
            <select id="selectCoupon" onChange={this.handleCouponSelected}>
              {/*<option disabled selected value> -- select coupon -- </option>*/}
              <option value="0">No Coupon</option>
              {listCoupons}
            </select>
          </div>
        </div>


        <div className="card" id="ProductsConfirm">
          <div className="card-body">
            <h4>Your Order</h4>
            <hr className="solid"></hr>
            <p>{listProducts}</p>
            <div>
              <hr className="solid"></hr>
              <p className="priceConfirm2">${this.state.order.subtotal}</p>
              <p className="priceConfirm1">Subtotal</p>
              <p className="priceConfirm2">${this.state.order.discount}</p>
              <p className="priceConfirm1">Discounts</p>
              <h4 className="priceConfirm2">${this.state.order.price}</h4>
              <h4 className="priceConfirm1">Total</h4>
            </div>
          </div>
        </div>

        <div className="card" id="paymentConfirm">
          <div className="card-body">
            <h4>Select Payment Method</h4>
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
  state => ({ user: state.fetchreducer }),
  { addorder }
)(PaymentPage);

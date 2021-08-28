import React from 'react';
import ProductDetail from "./ProductDetail"
var moment = require('moment');



class OrderDetail extends React.Component {

    constructor(props) {

        super(props);

        this.products = this.props.history.location.query.products;
        this.orderInfo = this .props.history.location.query.orderInfo;
    }

    formatProductCards = () => {
        return this.products.map((reading, index) => <ProductDetail reading={reading} key={index} />)
    }

    render() {
        let date = new Date();
        date.setTime(this.orderInfo.timemillis);
        const orderTime = moment(date).format('MMMM Do YYYY, h:mm a');

        return (
            <div>
                <div className="userScreen">
                    <h2>Order Detail</h2>
                    <div>
                        <div className="content-warp">

                            <div className="orderContainer">
                                <div className="card">
                                    <div className="card-header">
                                        <h4>Order Complete</h4>
                                    </div>
                                    <div className="card-body">
                                        {this.formatProductCards()}
                                        <div>
                                            <hr className="solid"></hr>
                                            <p className="priceConfirm2">${(this.orderInfo.subtotal).toFixed(2)}</p>
                                            <p className="priceConfirm1">Subtotal</p>
                                            {this.orderInfo.discount ?  <p className="priceConfirm2"> -${this.orderInfo.discount}</p>:<span/>}
                                            <p className="priceConfirm1">Discounts</p>
                                            <h4 className="priceConfirm2">${(this.orderInfo.totalPrice).toFixed(2)}</h4>
                                            <h4 className="priceConfirm1">Total</h4>
                                        </div>
                                        <div>
                                            <hr className="solid"></hr>
                                            {this.orderInfo.pickUp ? <h5>Pick Up At:</h5> : <h5>Delivery To:</h5>}
                                            <br/>
                                            <h6>{this.orderInfo.location}</h6>
                                        </div>
                                        <div>
                                            <hr className="solid"></hr>
                                            <h4>Order Info:</h4>
                                            <br/>
                                            <p className="showInRight">{this.orderInfo._id}</p>
                                            <p>Order Number</p>
                                            <p className="showInRight">Paypal</p>
                                            <p>Payment Method</p>
                                            <p className="showInRight">{orderTime}</p>
                                            <p>Order Time</p>
                                        </div>
                                    </div>
                                    <div className="card-footer">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}

export default OrderDetail;
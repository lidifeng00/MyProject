import React from 'react';
import Select from 'react-select';
import {connect} from "react-redux";
import cookie from 'react-cookies';
import { Modal, Button } from 'react-bootstrap';

const sizeOptions = [
    { value: "Regular", label: "Regular" },
    { value: "Large", label: "Large" },
  ];

const qtyOptions = [
{ value: "1", label: "1" },
{ value: "2", label: "2" },
{ value: "3", label: "3" },
{ value: "4", label: "4" },
{ value: "5", label: "5" },
{ value: "6", label: "6" },
{ value: "7", label: "7" },
{ value: "8", label: "8" },
{ value: "9", label: "9" },
{ value: "10", label: "10" },
];  

class FruitTeaOption extends React.Component {
    constructor(props) {
        super(props);
        
        this.state = {
            price : 4.49,
            size :"Regular",
            ice: 'Regular Ice',
            sweet: 'Standard Sweet',
            qty: 1,
            show: false
        };

        this.setSize = this.setSize.bind(this);
        this.setIce = this.setIce.bind(this);
        this.setSweet = this.setSweet.bind(this);
        this.setQty = this.setQty.bind(this);
        this.handleShow = this.handleShow.bind(this);
        this.handleClose = this.handleClose.bind(this);

    }


    setSize(event) {
        if (event.value === "Regular") {
            this._price.innerHTML = "$4.49";
            this.setState({price: 4.49});
        }
        else if (event.value === "Large") {
            this._price.innerHTML = "$4.99";
            this.setState({price: 4.99});
        }
        this.setState({size: event.value});
    }

    setIce(event) {
        this.setState({ice:event.target.value });
    }

    setSweet(event) {
        this.setState({sweet:event.target.value});
    }

    setQty(event) {
        this.setState({qty: event.value});
    }

    handleShow(event) {
        this.setState({show:true});
        event.preventDefault();
    }

    handleClose() {
        this.setState({show:false});
        cookie.save('drinkNum', parseInt(cookie.load('drinkNum')) + parseInt(this.state.qty), {path:"/"});
        cookie.save('orderNum', parseInt(cookie.load('orderNum')) + 1, {path:"/"});
        cookie.save('order' + cookie.load('orderNum'), JSON.stringify(this.props.title + '\,' + this.state.size + '\,' + this.state.price + '\,'+ this.state.ice
                      + '\,'+ this.state.sweet + '\,' + this.state.qty), {path:"/"});
        window.open("/order", "_self");
    }

    
    
    render() {
        var self = this;

        return (
            <form id="select-options" method="post" onSubmit={this.handleSubmit}>
                <h2>{ this.props.title}</h2>
                <h2 id="price" ref={
                        function(el) {
                          self._price= el;
                        }
                      }>$4.49</h2>
                <br />

                <h6>Select an option <span style={{color: "red"}}>*</span>:</h6>
                <Select options={sizeOptions} onChange={this.setSize} defaultValue = {sizeOptions[0]}  required/>
                <br /><br />


                <h6>Ice Level:</h6>
                <input type="radio" id="regulerIce" name="ice" value="Regular Ice" checked={this.state.ice === 'Regular Ice'}  onChange={this.setIce}/><label htmlFor="regulerIce">Regular Ice</label>
                <br />
                <input type="radio" id="lessIce" name="ice" value="Less Ice" checked={this.state.ice === 'Less Ice'}  onChange={this.setIce}/><label htmlFor="lessIce">Less Ice</label>
                <br />
                <input type="radio" id="noIce" name="ice" value="No Ice" checked={this.state.ice === 'No Ice'}  onChange={this.setIce}/><label htmlFor="noIce">No Ice</label>
                <br />
                <input type="radio" id="moreIce" name="ice" value="More Ice" checked={this.state.ice === 'More Ice'}  onChange={this.setIce}/><label htmlFor="moreIce">More Ice</label>
                <br />
                <br />

                <h6>Sweetness Level:</h6>
                <input type="radio" id="standardSweet" name="sweet" value="Standard Sweet" checked={this.state.sweet === 'Standard Sweet'}  onChange={this.setSweet}/><label htmlFor="standardSweet"> 50% Standard Sweet</label>
                <br />
                <input type="radio" id="lessSweet" name="sweet" value="Less Sweet" checked={this.state.sweet === 'Less Sweet'}  onChange={this.setSweet}/><label htmlFor="lessSweet"> 25% Less Sweet</label>
                <br />
                <input type="radio" id="moreSweet" name="sweet" value="More Sweet" checked={this.state.sweet === 'More Sweet'}  onChange={this.setSweet}/><label htmlFor="moreSweet"> 75% More Sweet</label>
                <br />
                <input type="radio" id="superSweet" name="sweet" value="Super Sweet" checked={this.state.sweet === 'Super Sweet'}  onChange={this.setSweet}/><label htmlFor="superSweet"> 100% Super Sweet</label>
                <br />
                <input type="radio" id="noSweet" name="sweet" value="No Sweet" checked={this.state.sweet === 'No Sweet'}  onChange={this.setSweet}/><label htmlFor="noSweet"> 0% No Sweet</label>
                <br />
                <br />

                <h6>Quantity <span style={{color: "red"}}>*</span>:</h6>
                <Select options={qtyOptions} onChange={this.setQty}  defaultValue = {qtyOptions[0]}/>
                <br />
                <br />

            <input id = "addCart" type="submit" onClick={this.handleShow} value={this.props.loginData.isAuth ? "Add to Cart" : "Login to order"} disabled={!this.props.loginData.isAuth}/>
             
             <Modal show={this.state.show} onHide={this.handleClose}>
                <Modal.Header>
                    <Modal.Title>Message</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <div style={{'textAlign':'center'}}>
                        <img src="https://img.icons8.com/color/96/000000/pass.png"/>
                    </div>
                    <br/>
                    Woohoo, { this.props.title} Successfully Added to Cart!
                </Modal.Body>
                <Modal.Footer>
                <Button variant="secondary" onClick={this.handleClose}>
                    OK
                </Button>
                </Modal.Footer>
            </Modal>

            </form>    
        )
    }
}

export default connect(
  state=>({loginData : state.syncInfo})
)(FruitTeaOption);
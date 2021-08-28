import React from 'react';
import cookie from 'react-cookies';
import productInfo from "../model/productInfo.json"

const CartCard = ({reading}) => {
    var products = productInfo.products;
    var imgFile = "";
    for (var i = 0; i < products.length; i++) {
        if (products[i].title === reading.name) {
            imgFile = products[i].imgFileName;
            break;
        }
    }
    const isExtra = reading.extras.length === 0;
    return (
        <div className="card" style={{width: "30vw", marginTop: "10px", borderRadius: "20px"}}>
            <div className="card-body" >
                <h4 className="card-title" >
                    {reading.name}
                    
                    <div className="dialog" style={{position: 'relative'}} >
                        <button style={{borderRadius: "20px", position: 'absolute', top: -30, right: 0,  backgroundColor:'transparent',
            borderStyle:'none'}} 
                            onClick={() => {
                            var n = parseInt(cookie.load('orderNum'));
                            for (var i = reading.index; i < n; i++) {
                                cookie.save('order' + i, cookie.load('order' + (i+1)), {path:"/"});
                            }
                            cookie.remove('order' + n);
                            cookie.save('drinkNum', parseInt(cookie.load('drinkNum')) - parseInt(reading.quantity), {path:"/"});
                            cookie.save('orderNum', n - 1, {path:"/"});
                            window.open("/cart", "_self");
                        }}><i className="fas fa-trash-alt"></i></button>
                    </div>
                </h4>
                

                <img className="orderImg" style ={{ float: 'left', borderRadius: "20px" }} src={"../../img/" + imgFile} alt = {reading.name}/>
                <div style={{display: "inline-block", clear: 'left'}}>
                    <p className="card-text">
                        Size: {reading.size}
                    </p>
                    <p className="card-text">
                        Ice Level: {reading.size}
                    </p>
                    <p className="card-text">
                        Sweetness Level: {reading.sweetness}
                    </p>
                    <p className="card-text">
                        Quantity: {reading.quantity}
                    </p>
                    {isExtra
                        ? <p className="card-text"></p>
                        : <p className="card-text"> Topping: {reading.extras} </p>
                    }
                </div>
            </div>
            <div className="card-footer" style={{backgroundColor: '#e5e1cd', borderRadius: "20px"}}>
                <div style={{fontSize: '20px', fontWeight: 'bold'}}>Price: ${(reading.price).toFixed(2)}</div>
                
            </div>
        </div>
    );
}


export default CartCard;
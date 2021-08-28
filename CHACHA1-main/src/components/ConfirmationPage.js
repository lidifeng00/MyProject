import React from 'react';
import cookie from 'react-cookies';
import { connect } from "react-redux";
import ReactDOM from "react-dom";
import { Image } from 'react-bootstrap';

class ConfirmationPage extends React.Component {
    render() {
        return (
            <div className="confirm">
                <div
                style={{
                    width:'60%', 
                    minHeight:'750px', 
                    backgroundColor:'white',
                    textAlign:'center',
                    marginLeft:'auto',
                    marginRight:'auto',
            }}>

                    <div className='image'
                        style={{
                            backgroundColor:'white',
                        }}>
                        <Image style={{marginTop:'5%'}}  src="https://img.icons8.com/bubbles/400/000000/shopping-cart.png" fluid/>
                    </div>
                    <hr style={{
                            borderWidth:'10px',
                            color: 'darkgray'
                        }}/>
                   
                    <div className='info' 
                        style={{
                            marginTop:'5%',
                            color:'#90bcf5'
                        }}
    
                    >
                        <h1>
                            Thank you！
                        </h1>
                        <h1>
                            Your order has been received.
                        </h1>
                        
                    </div>
                </div>

            </div>
        );
    }
}
export default connect(
    state => ({ user: state.fetchreducer })
)(ConfirmationPage);
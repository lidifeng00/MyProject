import React, {Component} from 'react';
import { Card } from 'react-bootstrap';
import { Button} from 'react-bootstrap';
import { Link } from 'react-router-dom';
import Heart from './Heart';


class OrderMilkTea extends Component {

    render() {
        var cardStyle = {
            width : '20rem',
            marginTop: '1rem' 
        }

        var imgStyle = {
            width : '20rem',
            height : '25rem',
        }

        return (

            <div>
                <div className = "products">
                    {this.props.products.slice(0, 3).map(product => (
                        <Card  key={product.title} className = "product" style={cardStyle}>
                            <img style = {imgStyle} src= {"../../img/" + product.imgFileName} alt = {product.title}/>
                            <Heart productId={product.productId} className="order-heart" />
                            <Card.Body>
                                <Card.Title>
                                    {product.title}
                                </Card.Title>
                                <Card.Text className="mb-2 text-muted">
                                    {product.description}
                                </Card.Text>
                                <Card.Title>
                                    {product.price}
                                </Card.Title>
                                <Link to={'/order/' + product.type + "/"+ product.productId} >
                                    <Button variant="light">ADD to Cart &nbsp;<i className="fas fa-cart-plus fa-lg"></i> </Button>
                                </Link>
                            </Card.Body>
                        </Card>
                    ))}
                </div>

            </div>
            
        )
    }

}


export default OrderMilkTea;
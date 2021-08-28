import React from 'react';
import { Link } from 'react-router-dom';
import products from '../model/products';
import Heart from './Heart';

class ProductCard extends React.Component {
  render() {
    const productInfo = products.getProductInfo(this.props.productId);
    return (
      <div className="card">
        <div className="card-body">
          <h4 className="card-title">{productInfo.title}</h4>
          <Heart productId={this.props.productId} className='card-heart' />
        </div>

        <Link to={'/order/' + productInfo.type + "/"+ this.props.productId} title="click to order">
          <img className="tea" src={process.env.PUBLIC_URL + "/img/" + productInfo.imgFileName} alt="#" />
        </Link>

      </div>
    );
  }
}

export default ProductCard;
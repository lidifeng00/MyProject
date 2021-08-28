import React from 'react';
import products from '../model/products';
import FruitTeaOption from './FruitTeaOption';

class FruitTeaSelect extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      productId: props.match.params.productId
    };
  }

  render() {
    const productInfo = products.getProductInfo(this.state.productId);
    if (!productInfo) { return (<div>Product not found</div>);}
    return (
      <div id="select-content">
        <img id="select-picture" src={ "../../img/" + productInfo.imgFileName } alt={this.productId} />
        
        <FruitTeaOption  title = {productInfo.title}/>
      
      </div>
    );
  }
}


export default FruitTeaSelect;
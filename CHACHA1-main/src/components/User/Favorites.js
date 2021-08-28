import React from 'react';

import ProductCard from '../ProductCard';

import {connect} from "react-redux";
import {fetchData} from "../../redux/actions";

import "./Favorites.css";

class Favorites extends React.Component {
  render() {
    let favorites = this.props.user.userData.favorites;
    if (!favorites) favorites = [];
    const products = favorites.map(value => {
      return(
        <ProductCard productId={value} />
      )
    });
    return (
      <div>
        <h1>Favorites</h1>
              <div id="favorites-grid">
                  {products}
              </div>
      </div>
    );
  }
}

export default connect(
  state => ({user: state.fetchreducer}),
  {fetchData}
)(Favorites);
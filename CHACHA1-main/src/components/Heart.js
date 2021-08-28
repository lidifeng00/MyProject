import React from 'react';
import { reqUpdateFavorite } from "../api";
import {connect} from "react-redux";
import {fetchData} from "../redux/actions";

class Heart extends React.Component {
  toggleFavorite() {
    let favorites = this.props.user.userData.favorites;
    const isFavorite = favorites.includes(this.props.productId);
    reqUpdateFavorite({ product: this.props.productId, isFavorite: !isFavorite})
      .then(response => {
        this.props.fetchData();
      });
  }
  render() {
    let favorites = this.props.user.userData.favorites;
    return (
      <div>
        {this.props.loginData.isAuth ?
          <img className="favorite-icon"
               src={process.env.PUBLIC_URL + "/img/" + (favorites && favorites.includes(this.props.productId) ? "heart-solid.png" : "heart-empty.png")}
               onClick={this.toggleFavorite.bind(this)}
               alt=''
          /> : null}
      </div>
    );
  }
}

export default connect(
  state => ({
    user: state.fetchreducer,
    loginData: state.syncInfo
  }),
  {fetchData}
)(Heart);
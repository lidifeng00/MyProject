import React from 'react';
import { Route, Switch } from 'react-router-dom';
import Favorites from './Favorites';
import OrderHistory from './OrderHistory';
import ProfileScreen from './ProfileScreen';
import Settings from './Settings';
import SideBar from './SideBar';
import Member from "./Member";
import './User.css';
import Coupon from "./Coupon";
import Auth from '../../utils/auth';
import './User.css';
import OrderDetail from "./OrderDetail";

class Users extends React.Component {
  render() {
    return (
      <div id="user-wrapper">
        <SideBar id="user-sidebar" />
        <div id="user-main">
          <Switch>
                <Route exact path='/user' component={Auth(ProfileScreen)} />
                <Route path ='/user/member' component={Auth(Member)}/>
                <Route path='/user/order-history' component={Auth(OrderHistory)} />
                <Route path='/user/order-detail/' component={Auth(OrderDetail)} />
                <Route path='/user/favorites' component={Auth(Favorites)} />
                <Route path='/user/settings' component={Auth(Settings)} />
                <Route path ='/user/coupon' component={Auth(Coupon)}/>
          </Switch>
        </div>
      </div>
    );
  }
}

export default Users;
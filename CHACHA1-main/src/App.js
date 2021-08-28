import React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';

import MainFooter from './components/MainFooter';
import MainNav from './components/MainNav';
import MainPage from './components/MainPage';
import ScrollToLocation from './components/ScrollToLocation';
import MilkTeaSelect from './components/MilkTeaSelect';
import FruitTeaSelect from './components/FruitTeaSelect';
import './App.css';
import Cart from "./components/Cart";
import ConfirmationPage from "./components/ConfirmationPage";
import PaymentPage from "./components/PaymentPage";
import SignInScreen from "./components/SigninScreen/SignInScreen";
import SignUpScreen from "./components/SigninScreen/SignUpScreen";
import Users from "./components/User/Users";
import cookie from 'react-cookies';
import Order from './components/Order';
import Location from './components/Location';

import AuthForLogin from '../src/utils/authForLogin';
import ProfileScreen from "./components/User/ProfileScreen";

import { connect } from "react-redux";
import { fetchData } from "./redux/actions";

import Auth from '../src/utils/auth'


class App extends React.Component {
  constructor(props) {
    super(props);
    if (!cookie.load('drinkNum'))
      cookie.save('drinkNum', 0, { path: "/" });
    if (!cookie.load('orderNum'))
      cookie.save('orderNum', 0, { path: "/" });
  }

  componentDidMount() {
    const userData = this.props.user.userData;
    if (this.props.loginData.isAuth && Object.keys(userData).length === 0) {
      this.props.fetchData();
    }
  }

  render() {
    return (
      <BrowserRouter>
        <MainNav />
        <ScrollToLocation />
        <Switch>
          <Route exact path='/' component={MainPage} />
          <Route exact path='/order' component={Order} />
          <Route exact path='/order/milkTea' component={Order} />
          <Route exact path='/order/fruitTea' component={Order} />
          <Route exact path='/order/specialtyDrinks' component={Order} />
          <Route path='/order/milkTea/:productId' component={MilkTeaSelect} />
          <Route path='/order/fruitTea/:productId' component={FruitTeaSelect} />
          <Route path='/order/specialtyDrinks/:productId' component={FruitTeaSelect} />
          <Route path='/location' component={Location} />

          <Route path='/cart' component={Cart} />
          <Route path='/payment' component={Auth(PaymentPage)} />
          <Route path='/confirmation' component={Auth(ConfirmationPage)} />
          <Route path='/signin' component={AuthForLogin(SignInScreen)} />
          <Route path='/signup' component={AuthForLogin(SignUpScreen)} />
          <Route path='/profile' component={Auth(ProfileScreen)} />
          <Route path='/user' component={Auth(Users)} />

        </Switch>
        <MainFooter />
      </BrowserRouter>
    );
  }
}

export default connect(
  state => ({
    user: state.fetchreducer,
    loginData: state.syncInfo
  }),
  { fetchData }
)(App);

import React from 'react';
import { Link } from 'react-router-dom';
import ListGroup from 'react-bootstrap/ListGroup';
import './SideBar.css';

class SideBar extends React.Component {
  render() {
    return (
      <div className="sidebar" style={{height:800}}>
        <ListGroup>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user'>Profile</Link></ListGroup.Item>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user/member'>Member Management</Link></ListGroup.Item>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user/coupon'>Coupon</Link></ListGroup.Item>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user/order-history'>Order History</Link></ListGroup.Item>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user/favorites'>Favorites</Link></ListGroup.Item>
          <ListGroup.Item as="li"><Link className='sidebar-link' to='/user/settings'>Settings</Link></ListGroup.Item>
        </ListGroup>
      </div>
    );
  }
}

export default SideBar;
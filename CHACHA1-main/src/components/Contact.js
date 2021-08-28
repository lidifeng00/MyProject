import React from 'react';
import Button from 'react-bootstrap/Button';
import Collapse from 'react-bootstrap/Collapse';

class Contact extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      open: false
    };
  }

  toggleCollapse() {
    this.setState({
      open: !this.state.open
    });
  }

  render() {
    return (
      <>
        <div className = 'socialMedia' style = {{textAlign:'center', marginBottom:'4px'}}>
          <img src="https://img.icons8.com/material-outlined/48/000000/instagram-new--v1.png"/>
          <img src="https://img.icons8.com/material-outlined/48/000000/twitter--v1.png"/>
          <img src="https://img.icons8.com/material-outlined/48/000000/facebook.png"/>
        </div>
      </>
    );
  }
}

export default Contact;


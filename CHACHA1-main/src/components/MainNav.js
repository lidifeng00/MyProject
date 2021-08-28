import React from 'react';
import Image from 'react-bootstrap/Image';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import Container from 'react-bootstrap/Container';
import Badge from 'react-bootstrap/Badge';
import cookie from 'react-cookies';

import { Link } from 'react-router-dom';

import SignIn from './SignIn';

class MainNav extends React.Component {
  render() {
    return (
      <Navbar expand="lg" variant="dark" style={{ backgroundColor: "#2E0000" }}>
        <Container>
          <Navbar.Brand href="/">
            <Image src={process.env.PUBLIC_URL + "/img/logo.jpg"} alt="logo" width="70" height="70" />
          </Navbar.Brand>
          <Navbar.Toggle />
          <Navbar.Collapse id="navbarSupportedContent" style={{ marginLeft: "3%" }}>
            <Nav className="me-auto mb-2 mb-lg-0">
              <Nav.Item>
                <Nav.Link as={Link} to="/" active aria-current="page">Home</Nav.Link>
              </Nav.Item>
              <NavDropdown title="Menu">
                <NavDropdown.Item href="/#milkTea">Milk Tea</NavDropdown.Item>
                <NavDropdown.Item href="/#fruitTea">Fruit Tea</NavDropdown.Item>
                <NavDropdown.Item href="/#specialty">Specialty Drinks</NavDropdown.Item>
              </NavDropdown>
              <Nav.Item>
                <Nav.Link href="/location">Location</Nav.Link>
              </Nav.Item>
              <Nav.Item>
                <Nav.Link href="/order">Online Order</Nav.Link>
              </Nav.Item>
            </Nav>
            <Nav.Item>
              <a className="btn" data-bs-toggle="tooltip" data-bs-placement="bottom" title="shopping cart" href="/cart" role="button">
                <i className="fas fa-shopping-cart fa-lg" style={{ color: "#616161" }}></i>
                <Badge bg="secondary">{cookie.load('drinkNum')}</Badge>
              </a>
            </Nav.Item>
            <Nav.Item>
              <SignIn></SignIn>
            </Nav.Item>
          </Navbar.Collapse>
        </Container>
      </Navbar>
    );
  }
}

export default MainNav;
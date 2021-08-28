import React from 'react';
import Carousel from 'react-bootstrap/Carousel';

class TeaCarousel extends React.Component {
  render() {
    return (
      <div>
        <h2 style={{ textAlign: "center", color: "#616161", fontFamily: "Trebuchet MS, sans-serif" }}>OUR TEA</h2>

        <Carousel id="imageCarousel" className="carousel slide" data-bs-ride="carousel">
            <Carousel.Item>
              <img src={process.env.PUBLIC_URL + "/img/p1.jpg"} className="d-block w-100" alt="milk tea" />
            </Carousel.Item>
            <Carousel.Item>
              <img src={process.env.PUBLIC_URL + "/img/p7.jpg"} className="d-block w-100" alt="bubble tea" />
              </Carousel.Item>
            <Carousel.Item>
              <img src={process.env.PUBLIC_URL + "/img/p3.jpg"} className="d-block w-100" alt="fruit tea" />
              </Carousel.Item>
            <Carousel.Item>
              <img src={process.env.PUBLIC_URL + "/img/p4.png"} className="d-block w-100" alt="mix berry tea" />
            </Carousel.Item>
          </Carousel>
      </div>
    );
  }
}

export default TeaCarousel;
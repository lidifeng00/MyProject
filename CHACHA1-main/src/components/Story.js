import React from 'react';
import Image from 'react-bootstrap/Image';

class Story extends React.Component {
  render() {
    return (
      <div id="story" style={{ margin: "60px" }}>
        <h2>ABOUT US | OUR STORY</h2>
        <h5>
          Our drinks originated from an instant inspiration of mixing cheese with tea. In 2020, with this spark of inspiration,we opened
          the first shop. Our mission is to bridge cultures and change the way people think about tea. We support artistic creation,make
          drinking tea become a style, a way of life.
        </h5>

        <Image src={process.env.PUBLIC_URL + "/img/about.png"} className="img-fluid mx-auto d-block" alt="about us" />
      </div>
    );
  }
}

export default Story;
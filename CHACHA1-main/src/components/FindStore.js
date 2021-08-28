import React from 'react';

class FindStore extends React.Component {
  render() {
    return (
      <div id="findStore" className="container-lg">
        <div className="content-warp" style={{ margin: "4%" }}>
          <h2 style={{ marginBottom: "4%" }}>Find a store near you</h2>
          <div className="alert alert-warning" role="alert">
            Due to COVID-19, locations may be operating under reduced capacity. See your
                  <a href="/location" className="alert-link"> local store</a> for details.
                </div>
          <a href="#">
            <img src={process.env.PUBLIC_URL + "/img/img-map.png"} width="100%" height="auto" />
          </a>
          <ul id="stores" className="list-group">
            <li className="list-group-item">75 Service St, San Jose, CA 95112</li>
            <li className="list-group-item">52 N Carson St, Carson City, NV 89701</li>
            <li className="list-group-item">22 W 5rd St, New York, NY 10019</li>
            <li className="list-group-item">800 Marlins Way, Miami, FL 33125</li>
          </ul>

        </div>
      </div>
    );
  }
}

export default FindStore;
import React from 'react';
import { Map, Marker, GoogleApiWrapper } from 'google-maps-react';

const locationData = {
  CA: {
    address: "75 Service St, San Jose, CA 95112",
    coords: {
      lat: 37.3694085722387,
      lng: -121.89064018857411
    }
  },
  NV: {
    address: "52 N Carson St, Carson City, NV 89701",
    coords: {
      lat: 39.164393774989215,
      lng: -119.76704854619771
    }
  },
  NY: {
    address: "22 W 5rd St, New York, NY 10019",
    coords: {
      lat: 40.611386428901646,
      lng: -73.81930127314598
    }
  },
  FL: {
    address: "800 Marlins Way, Miami, FL 33125",
    coords: {
      lat: 25.779310588086997,
      lng: -80.22149224465437
    }
  },
};

class Location extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      active: 'CA'
    };
  }

  setLocation(location) {
    this.setState({active: location});
  }

  render() {
    const containerStyle = {
      position: 'relative',
      width: '100%',
      height: '100%',
    }

    const buttonStyle = {
      border: 'none',
      backgroundColor: '#ffffff'
    }

    const buttons = Object.entries(locationData).map(([name, data]) => {
      return (
        <li key={name} className="list-group-item" onClick={this.setLocation.bind(this, name)}>
          {data.address}
          <button style={buttonStyle}><img src="https://img.icons8.com/color/32/000000/google-maps-new.png"  alt = 'search'/></button>
        </li>
      );
    });
    return (
      <div>
        <div className="mapContainer">
          <Map
            google={this.props.google}
            containerStyle={containerStyle}
            initialCenter={locationData[this.state.active].coords}
            center={locationData[this.state.active].coords}
            zoom={15}
          >
            <Marker position={locationData[this.state.active].coords} />
          </Map>

        </div>
        <div id="location-find-store">
          <ul id="stores" className="list-group">
            {buttons}
          </ul>
        </div>
      </div>
    )
  }
}

export default GoogleApiWrapper({
  apiKey: ('AIzaSyCjo5n_nywOm2COpZJhpZcxU9zsGYe-lYg')
})(Location)
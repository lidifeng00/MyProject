import React from 'react';

class MainFooter extends React.Component {
  render() {
    return (
      <div>
        <footer id="footer">
          <div className="footer-nav">
            <div id="footer-logo" style={{paddingRight: 10}}>
              <img src={process.env.PUBLIC_URL + "/img/logo.jpg"} className="rounded-circle" alt="logo" width="70" height="70" />
            </div>
          </div>
          <div className="copyright" > 
            <p>
              <br /> Copyright &copy; 2021 CHACHA
                  <br /> CONTACT EMAIL:
                  <a href="mailto:">chachatea@gmail.com</a>
              <br />
            </p>
          </div>
          
        </footer>
      </div>
    );
  }
}

export default MainFooter;
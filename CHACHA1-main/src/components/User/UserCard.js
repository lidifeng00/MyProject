import React from 'react';
import { Link } from 'react-router-dom';

class UserCard extends React.Component {
    render() {
        const {type} = this.props;
        return (
            <div className="card">
                <div className="card-body">
                    <h4 className="card-title">{type}</h4>
                </div>


            </div>
        );
    }
}

export default UserCard;
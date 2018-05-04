import React from 'react';
import PropTypes from 'prop-types';

export default function Home(props) {
  let { loading, locations } = props;

  if (loading) {
    return (
      <div className="body text-center my-3">
        <div className="fa-3x my-3">
        <i className="fas fa-spinner fa-spin"/>
        </div>
        <h4>Loading...</h4>
      </div>
    );
  } else {
    return (
      <div className="body">
        <div className="main-div">
          <h1 className="display-3 text-center mb-5">
            ¿Qu&eacute; vas a comer hoy?</h1>
          <ul>
            { locations.map((loc, idx) => (
                <li key={idx}
                    className={loc.id.toString()}>{ loc.name }</li>
              ))
            }
          </ul>
        </div>
      </div>
    );
  }
}

Home.propTypes = {
  loading: PropTypes.bool.isRequired,
  locations: PropTypes.array.isRequired
};

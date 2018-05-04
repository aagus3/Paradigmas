import React from 'react';
import PropTypes from 'prop-types';
import {Button} from 'reactstrap'

export default function Login(props) {
  let { loading, changePass, changeUser, handleSubmit } = props;
  
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
            Login</h1>
           <form>
                Usuario:<br/>
                <input type="text" name="usuario" onChange={(event) => changeUser(event)} /><br/>
                Contraseña:<br/>
                <input type="text" name="contrasena" onChange={(event) => changePass(event)} /><br/>
                <input type="submit" value="ENVIAR" onClick={() => handleSubmit()}/>
            </form> 
        </div>
      </div>
    );
  }
}

Login.propTypes = {
  loading: PropTypes.bool.isRequired,
};


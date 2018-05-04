import React from 'react';
import axios from 'axios';
import LoginP from '../presentational/login';


export default class Login extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      user : null,
      pass : null
    };
    
    this.handleSubmit = this.handleSubmit.bind(this);
    this.changeUser = this.changeUser.bind(this);
    this.changePass = this.changePass.bind(this);
  }
  
  handleSubmit() {
    console.log( this.state.user + this.state.pass);
  }
  
  changePass(e) {
    this.setState({pass: e.target.value});
  }
  
  changeUser(e) {
    this.setState({user: e.target.value})
  }

  componentDidMount() {
    axios
      .get("/api/locations")
      .then(
        response => this.setState({locations: response.data, loading: false})
      ).catch(
        error => {
          if (!error.response)
           alert(error);
          else if (error.response.data && error.response.status !== 404)
            alert(error.response.data);
          else
            alert(error.response.statusText);
          this.setState({loading: false});
        }
      );
  }

  render() {
    return (
      <LoginP loading={this.state.loading} changePass={this.changePass}
        changeUser={this.changeUser} handleSubmit={this.handleSubmit}
            />
    );
  }
}

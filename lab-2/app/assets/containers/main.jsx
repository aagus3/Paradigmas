import React from 'react';
import axios from 'axios';
import Home from '../presentational/home';


export default class Main extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      locations: []
    };
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
      <Home loading={this.state.loading}
            locations={this.state.locations}/>
    );
  }
}

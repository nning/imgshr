import React from 'react'

import Axios from 'axios'

import {decrypt} from '../utils/crypto'

class Placeholder extends React.Component {
  render() {
    return (
      <React.Fragment>
        {this.props.status}
      </React.Fragment>
    )
  }
}

export default class EncryptedImage extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      src: '',
      status: 'fetching',
      error: null
    }
  }

  componentDidMount() {
    this.fetchAndDecryptImage()
  }

  error(status, err) {
    this.setState({status: status, error: err})
  }

  fetchAndDecryptImage() {
    fetch(this.props.src)
      .then((response) => {
        this.setState({status: 'decrypting'})

        response.arrayBuffer()
          .then((body) => {
            decrypt(body, (decrypted) => {
              this.setState({
                src: 'data:image/jpeg;base64,' + btoa(decrypted),
                status: 'ready'
              })
            })
          })
          .catch((err) => {
            this.error('error:decrypting', err)
          })
      })
      .catch((err) => {
        this.error('error:fetching', err)
      })
  }

  render() {
    return this.state.status === 'ready' ? (
      <img
        src={this.state.src}
        title={this.props.title}
        alt={this.props.title}
        />
    ) : (
      <Placeholder status={this.state.status} error={this.state.error}/>
    )
  }
}

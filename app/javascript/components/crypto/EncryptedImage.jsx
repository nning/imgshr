import React from 'react'

import Axios from 'axios'
import {decrypt} from '../../utils/crypto'


class Placeholder extends React.Component {
  render() {
    return (
      <React.Fragment>
        <div className="title">{this.props.title}</div>
        <div>{this.props.status}</div>
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
    console.error(err)
  }

  fetchAndDecryptImage() {
    fetch(this.props.src)
      .then((response) => {
        if (!response.ok) throw response.status

        this.setState({status: 'decrypting'})

        response.arrayBuffer()
          .then((body) => {
            decrypt(body)
              .then((decrypted) => {
                this.setState({
                  src: 'data:image/jpeg;base64,' + btoa(decrypted),
                  status: 'ready'
                })
              })
              .catch((err) => {
                this.error('error:decrypting', err)
              })
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
      <Placeholder
        status={this.state.status}
        title={this.props.title}
        error={this.state.error}
        />
    )
  }
}

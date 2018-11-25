import React from 'react'

import Placeholder from '../Placeholder'

import {decrypt} from '../../utils/crypto'


export default class EncryptedImage extends React.Component {
  state = {
    src: '',
    status: 'fetching',
    error: null
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

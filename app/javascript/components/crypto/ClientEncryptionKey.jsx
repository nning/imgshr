import React from 'react'

import QRCode from '../QRCode'
import {getKeyBase64} from '../../utils/crypto'


export default class ClientEncryptionKey extends React.Component {
  state = {
    key: '',
    url: window.location.href,
    copiedStyle: {
      opacity: 0
    },
    qrcode: null
  }

  selectAllAndCopy = (e) => {
    const input = e.target

    input.focus()
    input.select()

    document.execCommand('copy')

    this.setState({
      copiedStyle: {
        opacity: 1,
        marginLeft: '1em'
      }
    })
  }

  getKey = () => {
    getKeyBase64().then((key) => {
      const url = window.location.href + '#' + key

      this.setState({
        key: key,
        url: url,
        qrcode: <QRCode content={url}/>
      })
    })
  }

  constructor() {
    super()
    document.addEventListener('sodium:ready', this.getKey)
  }

  render() {
    return (
      <React.Fragment>
        <div>
          <a href={this.state.url}>
            {this.state.qrcode}
          </a>
        </div>

        <div>
          <input
            value={this.state.key}
            onClick={this.selectAllAndCopy}
            readOnly/>

          <span className="copied" style={this.state.copiedStyle}>
            copied!
          </span>
        </div>
      </React.Fragment>
    )
  }
}

import React from 'react'

import QRCode from '../QRCode.jsx'
import Sodium from '../../utils/Sodium'


export default class ClientEncryptionKey extends React.Component {
  constructor(props) {
    super(props)

    this.selectAllAndCopy = this.selectAllAndCopy.bind(this)

    this.state = {
      key: '',
      url: window.location.href,
      copiedStyle: {
        opacity: 0
      }
    }
  }

  componentDidMount() {
    new Sodium().run((sodium, crypto) => {
      const url = window.location.href + '#' + key

      const key = crypto.getKeyBase64(sodium)
  	  this.setState({key: key, url: url})
    })
  }

  selectAllAndCopy(e) {
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

  render() {
    return (
      <React.Fragment>
        <div>
          <a href={this.state.url}>
            <QRCode content={this.state.url}/>
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

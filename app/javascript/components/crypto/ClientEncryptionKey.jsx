import React from 'react'

import QRCode from '../QRCode.jsx'

export default class ClientEncryptedKey extends React.Component {
  constructor(props) {
    super(props)

    this.selectAllAndCopy = this.selectAllAndCopy.bind(this)

    this.url = '#' + this.props.content

    this.state = {
      copiedStyle: {
        opacity: 0
      }
    }
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
          <a href={this.url}>
            <QRCode content={this.url}/>
          </a>
        </div>

        <div>
          <input
            value={this.props.content}
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

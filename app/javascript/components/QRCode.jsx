import React from 'react'

import qrcode from 'qrcode'

export default class QRCode extends React.Component {
  componentDidMount() {
    qrcode.toCanvas(this.canvas, this.props.content, (err) => {
      if (err) console.error(err)
    })
  }

  render() {
    return <canvas ref={canvas => this.canvas = canvas}/>
  }
}

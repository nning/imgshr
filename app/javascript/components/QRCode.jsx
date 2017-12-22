import React from 'react'

import qrcode from 'qrcode'

export default class QRCode extends React.Component {
  componentDidMount() {
    const content = JSON.stringify(this.props.content)
    qrcode.toCanvas(this.canvas, content, (err) => {
      if (err) console.error(err)
    })
  }

  render() {
    return <canvas ref={canvas => this.canvas = canvas}/>
  }
}

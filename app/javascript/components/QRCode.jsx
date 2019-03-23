import React from 'react'

import qrcode from 'qrcode'


export default class QRCode extends React.PureComponent {
  componentDidMount() {
    this.updateCanvas()
  }

  componentWillUpdate() {
    this.updateCanvas()
  }

  updateCanvas() {
    qrcode.toCanvas(this.canvas, this.props.content, (err) => {
      if (err) console.error(this.props.content, err)
    })
  }

  render() {
    return <canvas ref={canvas => this.canvas = canvas}/>
  }
}

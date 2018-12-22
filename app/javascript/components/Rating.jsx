import React from 'react'

import Rater from 'react-rater'
import 'react-rater/lib/react-rater.css'


export default class Rating extends React.PureComponent {
  onRate = (x) => {
    console.log('onRate', x)
  }

  render() {
    return (
      <Rater
        {...this.props}
        onRate={this.onRate}
      />
    )
  }
}

import React from 'react'

import EncryptedImage from './EncryptedImage'
import LazyLoad from 'react-lazyload'

export default class LazyEncryptedImage extends React.Component {
  render() {
    return (
      <LazyLoad height={250} once>
        <EncryptedImage {...this.props}/>
      </LazyLoad>
    )
  }
}

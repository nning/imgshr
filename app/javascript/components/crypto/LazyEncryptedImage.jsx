import React from 'react'

import EncryptedImage from './EncryptedImage.jsx'
import LazyLoad from 'react-lazyload'

export default class LazyEncryptedImage extends React.Component {
  render() {
    return (
      <LazyLoad height={200} once>
        <EncryptedImage {...this.props}/>
      </LazyLoad>
    )
  }
}

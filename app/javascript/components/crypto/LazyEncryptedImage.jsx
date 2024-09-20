import React from 'react'

import EncryptedImage from './EncryptedImage'
import LazyLoad from 'react-lazyload'

export default class LazyEncryptedImage extends React.PureComponent {
  render() {
    return (
      <LazyLoad height={325} once>
        <EncryptedImage {...this.props}/>
      </LazyLoad>
    )
  }
}

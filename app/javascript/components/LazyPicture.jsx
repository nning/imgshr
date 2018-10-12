import React from 'react'

import LazyLoad from 'react-lazyload'

export default class LazyPicture extends React.Component {
  render() {
    return (
      <LazyLoad height={200} once>
        <picture>
          {this.props.srcMobile !== null &&
            <source
              srcSet={this.props.srcMobile}
              media="(max-width: 768px)"
              />
          }

          <img
            src={this.props.src}
            title={this.props.title}
            alt={this.props.title}
            />
        </picture>
      </LazyLoad>
    )
  }
}

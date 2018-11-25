import React from 'react'

import LazyLoad from 'react-lazyload'

import Placeholder from './Placeholder'


export default class LazyPicture extends React.Component {
  state = {
    error: false
  }

  onError = (e) => {
    this.setState({error: true})
    setTimeout(this.afterTimeout, 30000)
  }

  afterTimeout = () => {
    this.setState({error: false})
  }

  render() {
    return (
      <LazyLoad height={200} once>
        {this.state.error ||
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
              onError={this.onError}
              />
          </picture>
        }

        {this.state.error &&
          <Placeholder
            status="error:fetching"
            icon="hourglass"
            statusText="Not ready, yet"
            title={this.props.title}
            />
        }
      </LazyLoad>
    )
  }
}

import React from 'react'

import LazyLoad from 'react-lazyload'

import Placeholder from './Placeholder'


export default class LazyPicture extends React.Component {
  state = {
    loaded: false,
    error: false
  }

  onLoad = (e) => {
    this.setState({loaded: true})
  }

  onError = (e) => {
    this.setState({error: true})
    setTimeout(this.afterTimeout, 30000)
  }

  afterTimeout = () => {
    this.setState({error: false})
  }

  isFetching = () => {
    return !this.state.loaded && !this.state.error
  }

  isError = () => {
    return !this.state.loaded && this.state.error
  }

  pictureClass = () => {
    if (this.state.loaded && !this.state.error) return null;
    return 'hidden';
  }

  render() {
    return (
      <LazyLoad height={200} once>
        <React.Fragment>
          {!this.state.error &&
            <picture className={this.pictureClass()}>
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
                onLoad={this.onLoad}
                onError={this.onError}
                />
            </picture>
          }

          {this.isFetching() &&
            <Placeholder
              status="fetching"
              title={this.props.title}
              />
          }

          {this.isError() &&
            <Placeholder
              status="error:fetching"
              icon="hourglass"
              statusText="Not ready, yet"
              title={this.props.title}
              />
          }
        </React.Fragment>
      </LazyLoad>
    )
  }
}

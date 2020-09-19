import React from 'react'

import Placeholder from './Placeholder'


export default class LazyPicture extends React.PureComponent {
  state = {
    loaded: false,
    error: false
  }

  onLoad = (e) => {
    this.setState({loaded: true})
  }

  onError = (e) => {
    this.setState({error: true})
    setTimeout(this.afterTimeout, 15000)
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
    if (this.state.loaded && !this.state.error) return null
    return 'hidden'
  }

  render() {
    return (
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
              loading="lazy"
            />
          </picture>
        }

        {this.isFetching() &&
          <Placeholder
            status="fetching"
            title={this.props.title}
            height={this.props.height}
            width={this.props.width}
          />
        }

        {this.isError() &&
          <Placeholder
            status="error:fetching"
            icon="hourglass"
            statusText="Not ready, yet"
            title={this.props.title}
            height={this.props.height}
            width={this.props.width}
          />
        }
      </React.Fragment>
    )
  }
}

import React from 'react'

import fileSize from '../utils/filesize'

export default class ProgressBar extends React.Component {
  render() {
    if (this.props.current == 0 && this.props.hide) {
      return null
    }

    return (
      <div className="progress">
        <div className="progress-bar progress-bar-striped active"
             role="progressbar"
             aria-valuenow={this.props.current}
             aria-valuemin={this.props.min}
             aria-valuemax={this.props.max}
             style={{width: this.props.current + '%'}}>

          <span className="sr-only">
            {this.props.current + '% Complete'}
          </span>
        </div>
      </div>
    )
  }
}

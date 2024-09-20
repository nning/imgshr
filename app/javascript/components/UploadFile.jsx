import React from 'react'

import fileSize from '../utils/filesize'

import Icon from './Icon'
import UploadFileActions from './UploadFileActions'

export default class UploadFile extends React.PureComponent {
  hasErrors() {
    return this.props.errors &&
      Boolean(Object.keys(this.props.errors).length)
  }

  render() {
    let progress = parseInt(this.props.progress)
    progress = progress ? `${progress}%` : this.props.progress

    if (this.hasErrors()) {
      progress = '⚠️'
    }

    return (
      <tr className="upload__file">
        <td>
          <Icon name="file"/>
        </td>

        <td className="upload__file__name">
          {this.props.name}

          {this.hasErrors() && this.props.errors.base.map((error) => {
            return (
              <div className="upload__file__error" key={error}>
                {error}
              </div>
            )
          })}
        </td>

        <td className="upload__file__size">
          {fileSize(this.props.size)}
        </td>

        <td className="upload__file__status">
          {Boolean(this.props.uploading) &&
            <div className="upload__file__progress">
              {progress}
            </div>
          }

          {!this.props.uploading &&
            <UploadFileActions remove={this.props.remove}/>
          }
        </td>
      </tr>
    )
  }
}

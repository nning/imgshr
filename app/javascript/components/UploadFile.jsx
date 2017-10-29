import React from 'react'

import fileSize from '../utils/filesize'

import Icon from './Icon.jsx'
import UploadFileActions from './UploadFileActions.jsx'

export default class UploadFile extends React.Component {
  render() {
    return (
      <tr className="upload__file">
        <td>
          <Icon name="file"/>
        </td>

        <td className="upload__file__name">
          {this.props.file.obj.name}
        </td>

        <td className="upload__file__size">
          {fileSize(this.props.file.obj.size)}
        </td>

        <td className="upload__file__status">
          <div className="upload__file__progress">
            {this.props.file.progress}%
          </div>

          <UploadFileActions remove={this.props.file.remove}/>
        </td>
      </tr>
    )
  }
}

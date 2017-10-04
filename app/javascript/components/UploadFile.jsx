import React from 'react'

import fileSize from '../utils/filesize'

export default class UploadFile extends React.Component {
  render() {
    return (
      <tr className="upload__file">
        <td>
          <span className="glyphicon glyphicon-file"></span>
        </td>

        <td className="upload__file__name">
          {this.props.file.obj.name}
        </td>

        <td className="upload__file__size">
          {fileSize(this.props.file.obj.size)}
        </td>

        <td className="upload__file__progress">
          {this.props.file.progress}%
        </td>
      </tr>
    )
  }
}

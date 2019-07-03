import React from 'react'

import UploadFile from './UploadFile'

export default class UploadList extends React.Component {
  render() {
    const files = this.props.files.map((file) => {
      const key = [file.obj.name, file.obj.size].join('-')

      return (
        <UploadFile
          key={key}
          name={file.obj.name}
          size={file.obj.size}
          progress={file.progress}
          remove={file.remove}
          uploading={this.props.uploading}
        />
      )
    })

    if (this.props.files.length) {
      return (
        <table
          className="
            upload__list
            table
            table-striped
            table-condensed
            table-hover
          "
        >
          <tbody>
            {files}
          </tbody>
        </table>
      )
    } else {
      return <div className="upload__list"/>
    }
  }
}

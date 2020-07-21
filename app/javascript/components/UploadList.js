import React from 'react'

import UploadFile from './UploadFile'

export default class UploadList extends React.Component {
  shouldComponentUpdate() {
    // TODO Work-around for upload update callback in Upload component not
    //      updating the individual file's progress in the state
    return true
  }

  // TODO Make it completely compatible to the way Rails transforms file names
  replaceSpecialChars(s) {
    return s.replace(/:/, '-')
  }

  render() {
    const files = this.props.files.map((file) => {
      const key = [file.obj.name, file.obj.size].join('-')

      const name = this.replaceSpecialChars(file.obj.name)
      const errors = this.props.errors[name]

      return (
        <UploadFile
          key={key}
          name={file.obj.name}
          size={file.obj.size}
          progress={file.progress}
          remove={file.remove}
          uploading={this.props.uploading}
          errors={errors}
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

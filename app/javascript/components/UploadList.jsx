import React from 'react'

import UploadFile from './UploadFile.jsx'

export default class UploadList extends React.Component {
  render() {
    const selectedFiles = this.props.selectedFiles.map((file) => {
      const key = [file.name, file.size].join('-')
      return <UploadFile key={key} file={file}/>
    })

    if (this.props.selectedFiles.length) {
      return (
        <table className="upload__list table table-striped table-condensed table-hover">
          <tbody>
            {selectedFiles}
          </tbody>
        </table>
      )
    } else {
      return <span/>
    }
  }
}

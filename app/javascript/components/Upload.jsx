import React from 'react'

import axios from 'axios'

import UploadList from './UploadList.jsx'

export default class Upload extends React.Component {
  constructor(props) {
    super(props)

    this.handleFiles = this.handleFiles.bind(this)
    this.upload = this.upload.bind(this)

    this.state = {
      selectedFiles: [],
      uploading: false,
    }
  }

  handleFiles(event) {
    const files = Array.from(event.target.files)

    let filesWithStatus = []
    files.forEach((file) => {
      filesWithStatus.push({
        obj: file,
        progress: 0,
        error: null
      })
    })

    this.setState({
      selectedFiles: filesWithStatus
    })
  }

  upload(event) {
    const files = this.state.selectedFiles

    this.setState({uploading: true})

    files.forEach((file, i) => {
      const data = new FormData()
      data.append('picture[image][]', file.obj)

      const config = {
        onUploadProgress: (e) => {
          file.progress = Math.round((e.loaded * 100) / e.total)
          this.forceUpdate()
        }
      }

      axios.post('', data, config)
        .then(() => {
          if (i === files.length - 1 && window) {
            window.location.reload()
          }
        })
    })
  }

  uploadButtonClasses() {
    let classes = 'btn btn-success'

    if (!this.state.selectedFiles.length || this.state.uploading) {
      classes += ' disabled'
    }

    return classes
  }

  render() {
    return (
      <div>
        <div className="modal-body">
          <div className="alert alert-info">
            Please choose files for upload...
          </div>

          <input type="file" multiple onChange={this.handleFiles}>
          </input>

          <UploadList files={this.state.selectedFiles}/>
        </div>

        <div className="modal-footer">
          <button className={this.uploadButtonClasses()} type="submit" name="commit" onClick={this.upload}>
            <span className="glyphicon glyphicon-upload"></span>
            &nbsp;Upload!
          </button>

          <button className="btn btn-default" data-dismiss="modal">
            <span className="glyphicon glyphicon-remove"></span>
            &nbsp;Close
          </button>
        </div>
      </div>
    )
  }
}

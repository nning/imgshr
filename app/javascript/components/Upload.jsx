import React from 'react'

import axios from 'axios'

import UploadList from './UploadList.jsx'

export default class Upload extends React.Component {
  constructor(props) {
    super(props)

    this.handleFiles = this.handleFiles.bind(this)
    this.upload = this.upload.bind(this)

    this.url = '/api/!' + this.props.slug

    this.state = {
      selectedFiles: [],
      uploading: false,
    }
  }

  filesWithStatus(files) {
    let filesWithStatus = []
    files.forEach((file) => {
      filesWithStatus.push({
        obj: file,
        progress: 0,
        error: null
      })
    })

    return filesWithStatus
  }

  handleFiles(event) {
    const files = Array.from(event.target.files)

    this.setState({
      selectedFiles: this.filesWithStatus(files)
    })
  }

  getRequestConfig(file) {
    return {
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      onUploadProgress: (e) => {
        file.progress = Math.round((e.loaded * 100) / e.total)
        this.forceUpdate()
      }
    }
  }

  upload(event) {
    const files = this.state.selectedFiles
    const promises = []

    this.setState({uploading: true})

    files.forEach((file) => {
      const data = new FormData()
      const config = this.getRequestConfig(file)

      data.append('picture[image][]', file.obj)

      promises.push(axios.post(this.url, data, config))
    })

    Promise.all(promises)
      .then(() => {
        window.location.reload()
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

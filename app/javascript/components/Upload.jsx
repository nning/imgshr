import React from 'react'

import Axios from 'axios'
import PromiseQueue from 'promise-queue'

import Icon from './Icon.jsx'
import ProgressBar from './ProgressBar.jsx'
import UploadList from './UploadList.jsx'

import csrf from '../utils/csrf'

export default class Upload extends React.Component {
  constructor(props) {
    super(props)

    this.isButtonDisabled = this.isButtonDisabled.bind(this)
    this.handleFiles = this.handleFiles.bind(this)
    this.upload = this.upload.bind(this)

    this.url = ''

    this.state = {
      selectedFiles: [],
      uploading: false,
      totalProgress: 0
    }
  }

  removeFile(i) {
    this.setState((prev) => {
      const files = prev.selectedFiles
        .filter((_, k) => k !== i)
        .map((file) => file.obj)

      return {
        selectedFiles: this.filesWithStatus(files)
      }
    })
  }

  filesWithStatus(files) {
    let filesWithStatus = []

    files.forEach((file, i) => {
      filesWithStatus.push({
        obj: file,
        progress: 0,
        error: null,
        remove: () => this.removeFile(i)
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

  totalProgress(files) {
    const progress = files
      .map((file) => file.progress)
      .reduce((a, b) => a + b, 0)

    return parseInt((progress / (files.length * 100)) * 100)
  }

  getRequestConfig(file) {
    return {
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      onUploadProgress: (e) => {
        file.progress = Math.round((e.loaded * 100) / e.total)

        this.setState((prev) => {
          return {
            totalProgress: this.totalProgress(prev.selectedFiles)
          }
        })
      }
    }
  }

  appendAndUpload(config, uploadFile) {
    const promises = []
    const queue = new PromiseQueue(2, Infinity)

    const data = csrf.getFormData(this)
    data.append('picture[image][]', uploadFile)

    promises.push(queue.add(() => {
      return Axios.post(this.url, data, config)
    }))

    Promise.all(promises)
      .then(() => {
        window.location.reload()
      })
  }

  upload(event) {
    const files = this.state.selectedFiles

    this.setState({uploading: true})

    files.forEach((file) => {
      const config = this.getRequestConfig(file)

      if (typeof imgshrCrypto === 'undefined') {
        this.appendAndUpload(config, file.obj)
        return
      }

      file.progress = 'encrypting...'
      imgshrCrypto.encrypt(file.obj, (encrypted) => {
        const encryptedFile = new File(
          [encrypted],
          file.obj.name + '.bin',
          {type: 'application/octet-stream'}
        )

        this.appendAndUpload(config, encryptedFile)
      })
    })
  }

  isButtonDisabled() {
    return !this.state.selectedFiles.length || this.state.uploading
  }

  uploadButtonClasses() {
    let classes = 'btn btn-success'
    if (this.isButtonDisabled()) classes += ' disabled'

    return classes
  }

  render() {
    return (
      <div>
        <div className="modal-body">
          <div className="alert alert-info">
            Please choose files for upload...
          </div>

          <input type="file" multiple onChange={this.handleFiles}
            autoComplete="off"/>

          <UploadList files={this.state.selectedFiles}/>

          <ProgressBar min="0" max="100" current={this.state.totalProgress}
            hide="true"/>
        </div>

        <div className="modal-footer">
          <button className={this.uploadButtonClasses()} type="submit"
              disabled={this.isButtonDisabled()} name="commit"
              onClick={this.upload}>
            <Icon name="upload"/>
            &nbsp;Upload!
          </button>

          <button className="btn btn-default" data-dismiss="modal">
            <Icon name="remove"/>
            &nbsp;Close
          </button>
        </div>
      </div>
    )
  }
}

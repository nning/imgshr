import React from 'react'

import Axios from 'axios'
import PromiseQueue from 'promise-queue'

import Icon from './Icon'
import ProgressBar from './ProgressBar'
import UploadList from './UploadList'

import csrf from '../utils/csrf'
import {encrypt} from '../utils/crypto'

export default class Upload extends React.PureComponent {
  state = {
    selectedFiles: [],
    uploading: false,
    totalProgress: 0
  }

  url = ''


  handleFiles = (event) => {
    const files = Array.from(event.target.files)

    this.setState({
      selectedFiles: this.filesWithStatus(files)
    })
  }

  isButtonDisabled = () => {
    return !this.state.selectedFiles.length || this.state.uploading
  }

  upload = (event) => {
    const files = this.state.selectedFiles
    const promises = []
    const queue = new PromiseQueue(2, Infinity)

    const appendQueue = f => promises.push(queue.add(f))

    this.setState({uploading: true})

    files.forEach((file) => {
      const config = this.getRequestConfig(file)

      if (typeof sodium === 'undefined') {
        appendQueue(this.getUploadFunction(config, file.obj))
        return
      }

      appendQueue(() => {
        return new Promise((resolve) => {
          file.progress = 'encrypting...'

          encrypt(file.obj).then((encrypted) => {
            const encryptedFile = new File(
              [encrypted],
              `${file.obj.name}.bin`,
              {type: 'application/octet-stream'}
            )

            this.getUploadFunction(config, encryptedFile)()
              .then(() => resolve())
          })
        })
      })
    })

    Promise.all(promises)
      .then(() => window.location.reload())
  }


  filesWithStatus(files) {
    const filesWithStatus = []

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

  getUploadFunction(config, uploadFile) {
    const data = csrf.getFormData(this)
    data.append('picture[image][]', uploadFile)

    return () => {
      return Axios.post(this.url, data, config)
    }
  }

  removeFile(i) {
    this.setState((prev) => {
      const files = prev.selectedFiles
        .filter((_, k) => k !== i)
        .map(file => file.obj)

      return {
        selectedFiles: this.filesWithStatus(files)
      }
    })
  }

  totalProgress(files) {
    const progress = files
      .map(file => file.progress)
      .reduce((a, b) => a + b, 0)

    return parseInt((progress / (files.length * 100)) * 100)
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

          <input
            type="file"
            multiple
            onChange={this.handleFiles}
            autoComplete="off"
          />

          <UploadList
            files={this.state.selectedFiles}
            uploading={this.state.uploading}
          />

          <ProgressBar
            min="0"
            max="100"
            current={this.state.totalProgress}
            hide="true"
          />
        </div>

        <div className="modal-footer">
          <button
            className={this.uploadButtonClasses()}
            type="submit"
            disabled={this.isButtonDisabled()}
            name="commit"
            onClick={this.upload}
          >
            <Icon name="upload"/>
            &nbsp;Upload!
          </button>

          <button
            type="button"
            className="btn btn-default"
            data-dismiss="modal"
          >
            <Icon name="remove"/>
            &nbsp;Close
          </button>
        </div>
      </div>
    )
  }
}

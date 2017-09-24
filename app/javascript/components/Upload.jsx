import React from 'react'

import UploadList from './UploadList.jsx'

export default class Upload extends React.Component {
  constructor(props) {
    super(props)

    this.handleFiles = this.handleFiles.bind(this)

    this.state = {
      selectedFiles: []
    }
  }

  handleFiles(event) {
    this.setState({
      selectedFiles: Array.from(event.target.files)
    })
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

          <UploadList selectedFiles={this.state.selectedFiles}/>
        </div>

        <div className="modal-footer">
          <button className="btn btn-success disabled" type="submit" name="commit">
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

import {Component} from 'react'

import Icon from './Icon'

export default class UploadFileAction extends Component {
  render() {
    return (
      <div className="upload__file__actions">
        <Icon name="trash" onClick={this.props.remove}/>
      </div>
    )
  }
}

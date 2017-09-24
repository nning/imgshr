import React from 'react'

export default class UploadFile extends React.Component {
  constructor(props) {
    super(props)

    const file = props.file

    this.state = {
      name: file.name,
      size: file.size
    }
  }

  fileSize(bytes) {
    const x = 1024;
    const units = ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB']

    if (Math.abs(bytes) < x) {
        return bytes + ' B';
    }

    let u = -1;
    do {
      bytes /= x;
      ++u;
    } while(Math.abs(bytes) >= x && u < units.length - 1);

    return bytes.toFixed(1) + ' ' + units[u];
  }

  render() {
    return (
      <tr className="upload__file">
        <td>
          <span className="glyphicon glyphicon-file"></span>
        </td>

        <td className="upload__file__name">
          {this.state.name}
        </td>

        <td className="upload__file__size">
          {this.fileSize(this.state.size)}
        </td>
      </tr>
    )
  }
}

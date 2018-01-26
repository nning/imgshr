import React from 'react'

import csrf from '../../utils/csrf'


export default class AsyncCheckbox extends React.Component {
  onChange = (e) => {
    const data = csrf.getFormData(this)
    data.append(this.props.name, e.target.checked)

    const xhr = new XMLHttpRequest();
    xhr.open('PUT', this.props.uri)

    xhr.onload = () => {
      if (xhr.status === 200 && this.props.reload) {
        window.location.reload()
      }
    }

    xhr.send(data)
  }

  render() {
    return (
      <input
        type="checkbox"
        name={this.props.name}
        defaultChecked={this.props.checked}
        onChange={this.onChange}
      />
    )
  }
}

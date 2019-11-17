import React from 'react'

import Axios from 'axios'

import csrf from '../utils/csrf'


export default class AsyncCheckbox extends React.PureComponent {
  onChange = (e) => {
    const data = csrf.getFormData(this)
    data.append(this.props.name, e.target.checked)

    Axios.put(this.props.uri, data)
      .then(() => {
        if (this.props.reload) window.location.reload()
      })
  }

  render() {
    return (
      <>
        <input
          type="checkbox"
          id={this.props.name}
          name={this.props.name}
          defaultChecked={this.props.checked}
          onChange={this.onChange}
        />

        <label htmlFor={this.props.name}>
          {this.props.label}
        </label>
      </>
    )
  }
}

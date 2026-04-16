import React from 'react'

import csrf from '../utils/csrf'


export default class AsyncCheckbox extends React.PureComponent {
  onChange = (e) => {
    const data = csrf.getFormData(this)
    data.append(this.props.name, e.target.checked)

    fetch(this.props.uri, {
      method: 'PUT',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: data,
      credentials: 'same-origin'
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`Request failed with status ${response.status}`)
        }
      })
      .then(() => {
        if (this.props.reload) window.location.reload()
      })
      .catch(() => {
        e.target.checked = !e.target.checked
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

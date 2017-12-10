import React from 'react'
import ReactDOM from 'react-dom'

import Axios from 'axios'

import csrf from '../utils/csrf'


export default class AsyncCheckbox extends React.Component {
  constructor(props) {
    super(props)

    this.onChange = this.onChange.bind(this)
  }

  onChange(e) {
    const data = csrf.getFormData(this)
    data.append(this.props.name, e.target.checked)

    Axios.put(this.props.uri, data)
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

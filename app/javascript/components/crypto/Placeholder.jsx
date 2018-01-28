import React from 'react'

import Icon from '../Icon'


const ICON_MAP = {
  fetching: 'download',
  decrypting: 'lock',
  'error:fetching': 'remove-circle',
  'error:decrypting': 'remove-circle'
}

export default class Placeholder extends React.Component {
  render() {
    return (
      <div className="placeholder">
        <Icon name={ICON_MAP[this.props.status]}/>
        <div className="title">{this.props.title}</div>
        <div>{this.props.status}</div>
      </div>
    )
  }
}

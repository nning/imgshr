import React from 'react'

import Icon from './Icon'


const ICON_MAP = {
  fetching: 'download',
  decrypting: 'lock',
  'error:fetching': 'remove-circle',
  'error:decrypting': 'remove-circle'
}

export default class Placeholder extends React.PureComponent {
  render() {
    return (
      <div className="placeholder" style={{width: this.props.width}}>
        <Icon name={this.props.icon || ICON_MAP[this.props.status]}/>
        <div className="title">{this.props.title}</div>
        <div>{this.props.statusText || this.props.status}</div>
      </div>
    )
  }
}

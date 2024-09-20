import React from 'react'

import Icon from './Icon'


const ICON_MAP = {
  fetching: 'download',
  decrypting: 'lock',
  'error:fetching': 'remove-circle',
  'error:decrypting': 'remove-circle',
  'error:invalid': 'remove-circle'
}

export default class Placeholder extends React.PureComponent {
  render() {
    const {width, height} = this.props
    const styles = {}

    if (height && width) {
      styles.width = 325 * (width || 1) / (height || 1)
      styles.minWidth = 'unset'

      styles.height = `calc((100vw - 10px) * ${height / width}`
    }

    return (
      <div className="placeholder" style={styles}>
        <Icon name={this.props.icon || ICON_MAP[this.props.status]}/>

        <div className="title">
          {this.props.title}
        </div>

        <div>
          {this.props.statusText || this.props.status}
        </div>
      </div>
    )
  }
}

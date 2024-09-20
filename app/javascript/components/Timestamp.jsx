import React from 'react'
// import ReactDOM from 'react-dom'

import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'

dayjs.extend(relativeTime)

export default class Timestamp extends React.PureComponent {
  constructor(props) {
    super(props)

    const now = dayjs(props.time)

    if (props.relative) {
      this.time = dayjs().to(now)
    } else {
      this.time = now.format('YYYY-MM-DD HH:mm:ss (Z)')
    }

    this.title = now.format('YYYY-MM-DD HH:mm:ss (dddd)')
  }

  // componentDidMount() {
  //   // eslint-disable-next-line react/no-find-dom-node, no-undef
  //   $(ReactDOM.findDOMNode(this)).tooltip()
  // }

  render() {
    return (
      <span
        title={this.title}
        data-toggle={this.props.tooltip ? 'tooltip' : null}
        className="timestamp"
      >
        {this.time}
      </span>
    )
  }
}

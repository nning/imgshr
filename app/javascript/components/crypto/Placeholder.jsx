import React from 'react'


export default class Placeholder extends React.Component {
  render() {
    return (
      <div className="placeholder">
        <div className="title">{this.props.title}</div>
        <div>{this.props.status}</div>
      </div>
    )
  }
}

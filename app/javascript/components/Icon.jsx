import React from 'react'

export default class Icon extends React.Component {
  render() {
    const classes = 'glyphicon glyphicon-' + this.props.name
    return (
      <span className={classes} onClick={this.props.onClick}/>
    )
  }
}

import React from 'react'

export default class InlineEdit extends React.Component {
  state = {
    editing: false
  }

  edit = () => {
    this.setState({editing: true})
    this.inputRef.current.focus()
  }

  save = () => {
    this.setState({editing: false})
  }

  constructor(props) {
    super(props)

    this.state.value = props.value
    this.inputRef = React.createRef()
  }

  render() {
    return (
      <React.Fragment>
        {!this.state.editing &&
          <span onClick={this.edit}>
            {this.state.value || this.props.placeholder}
          </span>
        }

        {this.state.editing &&
          <input ref={this.inputRef} defaultValue={this.state.value}/>
        }
      </React.Fragment>
    )
  }
}

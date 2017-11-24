import React from 'react'

import Icon from './Icon.jsx'

export default class ScrollToTop extends React.Component {
  constructor(props) {
    super(props)

    this.scrollStep = this.scrollStep.bind(this)
    this.scrollToTop = this.scrollToTop.bind(this)

    this.state = {
      intervalId: 0
    }
  }

  scrollStep() {
    if (window.pageYOffset === 0) {
      clearInterval(this.state.intervalId)
    }

    window.scroll(0, window.pageYOffset - this.props.scrollStepInPx)
  }

  scrollToTop() {
    const intervalId = setInterval(this.scrollStep, this.props.delayInMs)
    this.setState({ intervalId: intervalId })
  }

  render() {
      return (
        <button className="btn btn-default ScrollToTop" title='Back to top'
            onClick={this.scrollToTop}>
          <Icon name="chevron-up"/>
        </button>
      )
   }
}

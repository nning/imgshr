import React from 'react'

import Icon from './Icon'
import ScrollToTop from 'react-scroll-up'

export default class ScrollToTopButton extends React.PureComponent {
  render() {
    return (
      <ScrollToTop showUnder={320}>
        <button
          className="btn btn-default ScrollToTop"
          title="Back to top"
          type="button"
        >
          <Icon name="chevron-up"/>
        </button>
      </ScrollToTop>
    )
  }
}

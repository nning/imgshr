import ReactRailsUJS from 'react_ujs'
import Sodium from '../utils/Sodium'

const componentRequireContext = require.context('components/crypto', true)
ReactRailsUJS.useContext(componentRequireContext)

new Sodium().run((sodium, crypto) => {
  window.sodium = sodium
  window.imgshrCrypto = crypto

  crypto.resetUrlHash()
})

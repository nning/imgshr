import ReactRailsUJS from 'react_ujs'

const componentRequireContext = require.context('components/crypto', true)
ReactRailsUJS.useContext(componentRequireContext)

import * as crypto from '../utils/crypto'
import sodium from 'libsodium-wrappers-sumo'

sodium.ready.then(() => {
  window.sodium = sodium
  window.imgshrCrypto = crypto

  crypto.init()
})

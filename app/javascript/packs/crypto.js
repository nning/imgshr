import ReactRailsUJS from 'react_ujs'
import * as crypto from '../utils/crypto'

crypto.sodiumReady((resolve, reject, sodium) => {
  window.sodium = sodium
  window.imgshrCrypto = crypto
})

// Support component names relative to this directory:
const componentRequireContext = require.context('components/crypto', true)
ReactRailsUJS.useContext(componentRequireContext)

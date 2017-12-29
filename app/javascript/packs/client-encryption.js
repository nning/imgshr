import * as crypto from '../utils/crypto'
import sodium from 'libsodium-wrappers-sumo'

sodium.ready.then(() => {
  window.sodium = sodium
  window.imgshrCrypto = crypto

  crypto.init()
})

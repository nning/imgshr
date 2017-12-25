import * as imgshrCrypto from '../utils/crypto'
import sodium from 'libsodium-wrappers-sumo'

sodium.ready.then(() => {
  window.sodium = sodium
  window.imgshrCrypto = imgshrCrypto

  imgshrCrypto.init()
})

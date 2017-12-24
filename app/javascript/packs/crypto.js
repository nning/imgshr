import * as imgshrCrypto from '../utils/crypto'
import _sodium from 'libsodium-wrappers'

_sodium.ready.then(() => {
  imgshrCrypto.init(_sodium)
  window.imgshrCrypto = imgshrCrypto
})

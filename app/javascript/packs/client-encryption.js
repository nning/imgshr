import * as crypto from '../utils/crypto'

crypto.sodiumReady((resolve, reject, sodium) => {
  window.sodium = sodium
  window.imgshrCrypto = crypto
})

import '../components/crypto/ClientEncryptionKey'
import '../components/crypto/LazyEncryptedImage'

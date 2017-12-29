import * as crypto from '../utils/crypto'
crypto.resetUrlHash()

crypto.sodiumReady((resolve, reject, sodium) => {
  window.sodium = sodium
  window.imgshrCrypto = crypto
})

import '../components/crypto/ClientEncryptionKey.jsx'
import '../components/crypto/LazyEncryptedImage.jsx'

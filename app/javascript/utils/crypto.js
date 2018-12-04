// import sodium from 'libsodium-wrappers-sumo'

import {decode_utf8} from './encoding'


function resetUrlHash() {
  const url = window.location.href
  const i = url.indexOf('#')

  if (i < 0) return

  window.history.replaceState({}, null, url.slice(0, i))
}

export function getKey() {
  return sodiumReady((resolve, reject) => {
    const slug = document
      .querySelector('meta[itemprop="gallery:slug"]')
      .getAttribute('content')
    const item = slug + '_client_encrypted_key'

    const stored = localStorage.getItem(item)
    const hash = window.location.hash.slice(1)

    let k = new Uint8Array(sodium.crypto_secretbox_KEYBYTES)

    if (hash === '') {
      if (!stored) {
        k = sodium.crypto_secretbox_keygen()
        localStorage.setItem(item, sodium.to_base64(k))
      } else {
        const storedKey = sodium.from_base64(stored)

        for (let i in storedKey) {
          if (storedKey.hasOwnProperty(i)) k[i] = storedKey[i]
        }
      }
    } else {
      k = sodium.from_base64(hash)
      localStorage.setItem(item, sodium.to_base64(k))

      resetUrlHash()
    }

    resolve(k)
  })
}

export function getKeyBase64() {
  return getKey().then(sodium.to_base64)
}

export function encrypt(file) {
  return sodiumReady((resolve) => {
    const reader = new FileReader()
    reader.readAsBinaryString(file)

    reader.onload = () => {
      getKey().then((k) => {
        const n = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES)

        const encrypted = sodium.crypto_secretbox_easy(reader.result, n, k)

        const nonceAndEncrypted = new Uint8Array(n.length + encrypted.length)
        nonceAndEncrypted.set(n, 0)
        nonceAndEncrypted.set(encrypted, sodium.crypto_secretbox_NONCEBYTES)

        resolve(nonceAndEncrypted)
      })
    }
  })
}

export function decrypt(data) {
  return sodiumReady((resolve, reject) => {
    getKey().then((k) => {
      const NONCE_LENGTH = sodium.crypto_secretbox_NONCEBYTES

      const m0 = new Uint8Array(data)
      const m1 = new Uint8Array(m0.length - NONCE_LENGTH)
      m1.set(m0.slice(NONCE_LENGTH), 0)

      const n = new Uint8Array(NONCE_LENGTH)
      n.set(m0.slice(0, NONCE_LENGTH), 0)

      let decoded = null
      try {
        const decrypted = sodium.crypto_secretbox_open_easy(m1, n, k)
        decoded = decode_utf8(decrypted)
      } catch(e) {
        reject(e)
      }

      resolve(decoded)
    })
  })
}

export function sodiumReady(fn) {
  return new Promise((resolve, reject) => {
    sodium.ready.then(() => {
      fn(resolve, reject, sodium)
    })
  })
}

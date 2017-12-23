import naclFactory from 'js-nacl'

import React from 'react'
import ReactDOM from 'react-dom'

import Axios from 'axios'
import QRCode from '../components/QRCode.jsx'

const NONCE_LENGTH = 24

function getKey(nacl) {
  const slug = document.getElementById('gallery').getAttribute('slug')
  const item = slug + '_client_encrypted_key'

  let k = new Uint32Array(32)
  let stored = localStorage.getItem(item)

  if (!stored) {
    window.crypto.getRandomValues(k);
    localStorage.setItem(item, JSON.stringify(k))
  } else {
    const storedKey = JSON.parse(stored)

    for (let i in storedKey) {
      if (storedKey.hasOwnProperty(i)) k[i] = storedKey[i]
    }
  }

  return k
}

function fetchAndDecryptImages() {
  $('img[data-encrypted-src]').each((_, img) => {
    const src = img.getAttribute('data-encrypted-src')

    Axios.get(src, {responseType: 'arraybuffer'})
      .then((response) => {
        decrypt(response.data, (decrypted) => {
          img.src = 'data:image/jpeg;base64,' + btoa(decrypted)
        })
      })
  })
}

export function encrypt(file, callback) {
  const reader = new FileReader()
  reader.readAsBinaryString(file)

  reader.onload = () => {
    naclFactory.instantiate((nacl) => {
      const k = getKey(nacl)
      const n = nacl.crypto_secretbox_random_nonce()

      const encoded = nacl.encode_utf8(reader.result);
      const encrypted = nacl.crypto_secretbox(encoded, n, k)

      const nonceAndEncrypted = new Uint8Array(n.length + encrypted.length)
      nonceAndEncrypted.set(n, 0)
      nonceAndEncrypted.set(encrypted, NONCE_LENGTH)

      if (typeof callback === 'function') callback(nonceAndEncrypted)
    })
  }
}

export function decrypt(data, callback) {
  naclFactory.instantiate((nacl) => {
    const k = getKey(nacl)

    const m0 = new Uint8Array(data)
    const m1 = new Uint8Array(m0.length - NONCE_LENGTH)
    m1.set(m0.slice(NONCE_LENGTH), 0)

    const n = new Uint8Array(NONCE_LENGTH)
    n.set(m0.slice(0, NONCE_LENGTH), 0)

    const decrypted = nacl.crypto_secretbox_open(m1, n, k)
    const decoded = nacl.decode_utf8(decrypted)

    if (typeof callback === 'function') callback(decoded)
  })
}

export function init() {
  naclFactory.instantiate((nacl) => {
    ReactDOM.render(<QRCode content={JSON.stringify(getKey(nacl))}/>,
    document.getElementById('client_encrypted_key'))
  });

  fetchAndDecryptImages()
}

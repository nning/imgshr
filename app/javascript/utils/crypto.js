import naclFactory from 'js-nacl'

import React from 'react'
import ReactDOM from 'react-dom'

import Axios from 'axios'
import QRCode from '../components/QRCode.jsx'

function serializeSecrets(n, k) {
  return JSON.stringify({n: n, k: k})
}

function getSecrets(nacl) {
  const slug = document.getElementById('gallery').getAttribute('slug')
  const item = slug + '_client_encrypted_key'

  let stored = localStorage.getItem(item)

  let n = new Uint8Array(24)
  let k = new Uint32Array(32)

  if (!stored) {
    window.crypto.getRandomValues(k);
    n = nacl.crypto_secretbox_random_nonce()

    localStorage.setItem(item, serializeSecrets(n, k))
  } else {
    stored = JSON.parse(stored)

    const storedNonce = stored['n']
    const storedKey = stored['k']

    for (let i in storedNonce) {
      if (storedNonce.hasOwnProperty(i)) n[i] = storedNonce[i]
    }

    for (let i in storedKey) {
      if (storedKey.hasOwnProperty(i)) k[i] = storedKey[i]
    }
  }

  return [n, k]
}

function fetchAndDecryptImages() {
  $('img[data-encrypted-src]').each((_, img) => {
    const src = img.getAttribute('data-encrypted-src')

    Axios.get(src, {responseType: 'arraybuffer'})
      .then((response) => {
        decrypt(response.data)
      })
  })
}

export function encrypt(file, callback) {
  const reader = new FileReader()
  reader.readAsBinaryString(file)

  reader.onload = () => {
    naclFactory.instantiate((nacl) => {
      const [n, k] = getSecrets(nacl)

      const encrypted = nacl.crypto_secretbox(reader.result, n, k)
      console.log('encrypt', encrypted)

      if (typeof callback === 'function') callback(encrypted)
    })
  }
}

export function decrypt(data) {
  naclFactory.instantiate((nacl) => {
    const [n, k] = getSecrets(nacl)

    const a = new Uint8Array(data)
    const decrypted = nacl.crypto_secretbox_open(a, n, k)
    console.log('decrypt', decrypted)

    return decrypted
  })
}

export function init() {
  naclFactory.instantiate((nacl) => {
    const [n, k] = getSecrets(nacl)

    // const s = 'hello world'
    //
    // const m = nacl.encode_utf8(s)
    // const c = nacl.crypto_secretbox(m, n, k)
    //
    // const d = nacl.crypto_secretbox_open(c, n, k)
    // const m1 = nacl.decode_utf8(d)
    //
    // console.log(m1, s === m1);

    ReactDOM.render(<QRCode content={serializeSecrets(n, k)}/>,
    document.getElementById('client_encrypted_key'))
  });

  fetchAndDecryptImages()
}

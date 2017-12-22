import naclFactory from 'js-nacl'

import React from 'react'
import ReactDOM from 'react-dom'

import QRCode from '../components/QRCode.jsx'

function serializeSecrets(k, n) {
  return JSON.stringify({k: k, n: n})
}

function getSecrets(nacl) {
  const slug = document.getElementById('gallery').getAttribute('slug')
  const item = slug + '_client_encrypted_key'

  let stored = localStorage.getItem(item)

  let k = new Uint32Array(32)
  let n = new Uint8Array(24)

  if (!stored) {
    window.crypto.getRandomValues(k);
    n = nacl.crypto_secretbox_random_nonce()

    localStorage.setItem(item, serializeSecrets(k, n))
  } else {
    stored = JSON.parse(stored)

    const storedKey = stored['k']
    const storedNonce = stored['n']

    for (let i in storedKey) {
      if (storedKey.hasOwnProperty(i)) k[i] = storedKey[i]
    }

    for (let i in storedNonce) {
      if (storedNonce.hasOwnProperty(i)) k[i] = storedNonce[i]
    }
  }

  return [k, n]
}

naclFactory.instantiate((nacl) => {
  const [k, n] = getSecrets(nacl)

  const s = 'hello world'

  const m = nacl.encode_utf8(s)
  const c = nacl.crypto_secretbox(m, n, k)

  const d = nacl.crypto_secretbox_open(c, n, k)
  const m1 = nacl.decode_utf8(d)

  console.log(m1, s === m1);

  ReactDOM.render(<QRCode content={serializeSecrets(k, n)}/>,
    document.getElementById('client_encrypted_key'))
});

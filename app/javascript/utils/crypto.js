import React from 'react'
import ReactDOM from 'react-dom'

import {decode_utf8} from './encoding'


export function resetUrlHash() {
  const url = window.location.href
  const i = url.indexOf('#')

  if (i < 0) return

  window.history.replaceState({}, null, url.slice(0, i))
}

export function getKey(_sodium = sodium) {
  const slug = document.getElementById('gallery').getAttribute('data-slug')
  const item = slug + '_client_encrypted_key'

  const stored = localStorage.getItem(item)
  const hash = window.location.hash.slice(1)

  let k = new Uint8Array(_sodium.crypto_secretbox_KEYBYTES)

  if (hash === '') {
    if (!stored) {
      k = _sodium.crypto_secretbox_keygen()
      localStorage.setItem(item, sodium.to_base64(k))
    } else {
      const storedKey = _sodium.from_base64(stored)

      for (let i in storedKey) {
        if (storedKey.hasOwnProperty(i)) k[i] = storedKey[i]
      }
    }
  } else {
    k = sodium.from_base64(hash)
    localStorage.setItem(item, _sodium.to_base64(k))
  }

  return k
}

export function getKeyBase64(_sodium = sodium) {
  return _sodium.to_base64(getKey(_sodium))
}

export function encrypt(file, callback) {
  const reader = new FileReader()
  reader.readAsBinaryString(file)

  reader.onload = () => {
    const k = getKey()
    const n = sodium.randombytes_buf(sodium.crypto_secretbox_NONCEBYTES)

    const encrypted = sodium.crypto_secretbox_easy(reader.result, n, k)

    const nonceAndEncrypted = new Uint8Array(n.length + encrypted.length)
    nonceAndEncrypted.set(n, 0)
    nonceAndEncrypted.set(encrypted, sodium.crypto_secretbox_NONCEBYTES)

    if (typeof callback === 'function') callback(nonceAndEncrypted)
  }
}

export function decrypt(data, callback) {
  const NONCE_LENGTH = sodium.crypto_secretbox_NONCEBYTES
  const k = getKey()

  const m0 = new Uint8Array(data)
  const m1 = new Uint8Array(m0.length - NONCE_LENGTH)
  m1.set(m0.slice(NONCE_LENGTH), 0)

  const n = new Uint8Array(NONCE_LENGTH)
  n.set(m0.slice(0, NONCE_LENGTH), 0)

  const decrypted = sodium.crypto_secretbox_open_easy(m1, n, k)
  const decoded = decode_utf8(decrypted)

  if (typeof callback === 'function') callback(decoded)
}

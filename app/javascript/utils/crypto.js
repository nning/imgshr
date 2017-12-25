import React from 'react'
import ReactDOM from 'react-dom'

import Axios from 'axios'
import ClientEncryptedKey from '../components/ClientEncryptedKey.jsx'

import {decode_utf8} from './encoding'

function getKey() {
  const slug = document.getElementById('gallery').getAttribute('data-slug')
  const item = slug + '_client_encrypted_key'

  let k = new Uint8Array(sodium.crypto_secretbox_KEYBYTES)
  let stored = localStorage.getItem(item)

  if (!stored) {
    k = sodium.crypto_secretbox_keygen()
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
  document.querySelectorAll('img[data-encrypted-src][src=""]').forEach((img) => {
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

export function init() {
  const keyContainer = document.getElementById('client_encrypted_key')
  const key = sodium.to_base64(getKey())

  if (keyContainer) {
    const component = <ClientEncryptedKey content={key}/>
    ReactDOM.render(component, keyContainer)
  }

  fetchAndDecryptImages()
}

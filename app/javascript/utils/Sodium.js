import * as crypto from './crypto'
import sodium from 'libsodium-wrappers-sumo'


let sodiumInstance = null;

export default class Sodium {
  constructor(fn) {
    if (!sodiumInstance) sodiumInstance = this
    return sodiumInstance
  }

  run(fn) {
    sodium.ready.then(() => {
      fn(sodium, crypto)
    })
  }
}

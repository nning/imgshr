import sodium from 'libsodium-wrappers-sumo'

sodium.ready.then(() => {
  window.sodium = sodium
  document.dispatchEvent(new CustomEvent('sodium:ready'))
})

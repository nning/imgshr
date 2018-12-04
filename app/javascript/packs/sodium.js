import sodium from 'libsodium-wrappers-sumo'

sodium.ready.then(() => {
  window.sodium = sodium

  const event = new CustomEvent('sodium:ready', {bubbles: true})
  document.dispatchEvent(event)
})

import naclFactory from 'js-nacl'

naclFactory.instantiate((nacl) => {
  const k = new Uint32Array(32);
  window.crypto.getRandomValues(k);

  const m = nacl.encode_utf8('hello world');
  const n = nacl.crypto_secretbox_random_nonce();
  const c = nacl.crypto_secretbox(m, n, k);
  const m1 = nacl.crypto_secretbox_open(c, n, k);

  console.log(nacl.decode_utf8(m1), 'hello world' === nacl.decode_utf8(m1));
});

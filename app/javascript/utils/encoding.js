// Stolen from js-nacl:
// https://github.com/tonyg/js-nacl/blob/master/lib/nacl_factory.js#L49

export function encode_utf8(s) {
  return encode_latin1(unescape(encodeURIComponent(s)))
}

export function encode_latin1(s) {
  const result = new Uint8Array(s.length)

  for (let i = 0; i < s.length; i++) {
      const c = s.charCodeAt(i)
      if ((c & 0xff) !== c) {
        throw {message: "Cannot encode string in Latin1", str: s}
      }

      result[i] = (c & 0xff)
  }

  return result
}

export function decode_utf8(bs) {
  return decodeURIComponent(escape(decode_latin1(bs)))
}

function decode_latin1(bs) {
  const encoded = []
  for (let i = 0; i < bs.length; i++) {
    encoded.push(String.fromCharCode(bs[i]))
  }

  return encoded.join('')
}

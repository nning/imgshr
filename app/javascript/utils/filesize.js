export default function filesize(bytes) {
  const x = 1024;
  const units = ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB']

  if (Math.abs(bytes) < x) {
      return bytes + ' B';
  }

  let u = -1;
  do {
    bytes /= x;
    ++u;
  } while(Math.abs(bytes) >= x && u < units.length - 1);

  return bytes.toFixed(1) + ' ' + units[u];
}

let cachedParams

export function getParams(node) {
  if (!cachedParams) {
    const param = document.querySelector('meta[name="csrf-param"]')
      .getAttribute('content')
    const token = document.querySelector('meta[name="csrf-token"]')
      .getAttribute('content')

    cachedParams = [param, token]
  }

  return cachedParams
}

// export function getJsonData(node) {
//   const [param, token] = getParams(node)
//
//   let data = {}
//   data[param] = token
//
//   return data
// }

export function getFormData(node) {
  const data = new FormData()
  data.append(...getParams(node))

  return data
}

export default {getParams, getFormData}

import ReactDOM from 'react-dom'

let cachedParams

export function getParams(node) {
  if (!cachedParams) {
    const html = ReactDOM.findDOMNode(node).closest('html')

    const param = html.querySelector('meta[name="csrf-param"]')
      .getAttribute('content')
    const token = html.querySelector('meta[name="csrf-token"]')
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

export default { getParams, getFormData }

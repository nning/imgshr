import { Controller } from "@hotwired/stimulus"
import { encrypt } from "../lib/crypto"

function filesize(bytes) {
  const x = 1024
  const units = ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]

  if (Math.abs(bytes) < x) {
    return `${bytes} B`
  }

  let u = -1
  do {
    bytes /= x
    ++u
  } while (Math.abs(bytes) >= x && u < units.length - 1)

  return `${bytes.toFixed(1)} ${units[u]}`
}

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;")
}

function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content
}

export default class extends Controller {
  static targets = ["input", "list", "progress", "progressBar", "button"]
  static values = { encrypt: Boolean, url: String }

  connect() {
    this.files = []
    this.uploading = false
  }

  handleFiles(e) {
    const selected = Array.from(e.target.files)
    this.files = selected.map((file, i) => ({
      obj: file,
      progress: 0,
      error: null,
      index: i
    }))
    this.renderList()
    this.updateButton()
  }

  upload() {
    if (!this.files.length || this.uploading) return

    this.uploading = true
    this.updateButton()
    this.renderList()

    const concurrency = 2
    let nextIndex = 0
    const results = []

    const runNext = () => {
      if (nextIndex >= this.files.length) {
        return Promise.resolve()
      }

      const file = this.files[nextIndex++]
      return this.uploadFile(file).then((result) => {
        results.push(result)
        return runNext()
      })
    }

    const workers = []
    for (let i = 0; i < concurrency; i++) {
      workers.push(runNext())
    }

    Promise.all(workers)
      .then(() => {
        const errors = {}
        results.forEach((result) => {
          if (result.data && result.data.errors) {
            Object.assign(errors, result.data.errors)
          }
        })
        const hasFileErrors = this.files.some((file) => Boolean(file.error))

        if (Object.keys(errors).length || hasFileErrors) {
          this.uploading = false
          this.applyErrors(errors)
          this.updateButton()
          this.renderList()
        } else {
          window.location.reload()
        }
      })
      .catch(() => {
        this.uploading = false
        this.updateButton()
        this.renderList()
      })
  }

  uploadFile(file) {
    const url = this.urlValue

    return this.prepareFile(file).then((uploadFile) => {
      return new Promise((resolve) => {
        const xhr = new XMLHttpRequest()
        const data = new FormData()
        data.append("picture[image][]", uploadFile)
        const csrfParam = document.querySelector('meta[name="csrf-param"]')?.content
        const token = csrfToken()
        if (csrfParam && token) {
          data.append(csrfParam, token)
        }

        xhr.open("POST", url)
        xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest")

        xhr.upload.addEventListener("progress", (e) => {
          if (e.lengthComputable) {
            file.progress = Math.round((e.loaded * 100) / e.total)
            file.status = "uploading"
            this.updateProgress()
            this.renderList()
          }
        })

        xhr.addEventListener("load", () => {
          if (xhr.status < 200 || xhr.status >= 300) {
            file.error = `Upload failed (${xhr.status})`
            resolve({ file, data: { errors: {} } })
            return
          }
          try {
            const data = JSON.parse(xhr.responseText)
            resolve({ file, data })
          } catch {
            file.error = "Upload failed"
            resolve({ file, data: { errors: {} } })
          }
        })

        xhr.addEventListener("error", () => {
          file.error = "Upload failed"
          resolve({ file, data: { errors: {} } })
        })

        xhr.send(data)
      })
    })
  }

  prepareFile(file) {
    if (this.encryptValue) {
      file.progress = "encrypting..."
      file.status = "encrypting"
      this.renderList()

      return encrypt(file.obj).then((encrypted) => {
        return new File([encrypted], `${file.obj.name}.bin`, {
          type: "application/octet-stream"
        })
      })
    }

    return Promise.resolve(file.obj)
  }

  removeFile(e) {
    const index = parseInt(e.currentTarget.dataset.index)
    this.files = this.files.filter((_, i) => i !== index)
    this.files.forEach((f, i) => (f.index = i))
    this.renderList()
    this.updateButton()
  }

  renderList() {
    if (!this.files.length) {
      this.listTarget.innerHTML = ""
      this.progressTarget.style.display = "none"
      return
    }

    const html = this.files.map((file, i) => {
      const progress = file.error
        ? "⚠️"
        : file.progress === "encrypting..."
          ? "encrypting..."
          : `${file.progress}%`

      const errorHtml = file.error
        ? `<div class="upload__file__error">${escapeHtml(file.error)}</div>`
        : ""

      const actionsHtml = this.uploading
        ? ""
        : `<span class="upload__file__actions">
             <span class="glyphicon glyphicon-trash"
               data-action="click->upload#removeFile"
               data-index="${i}"></span>
           </span>`

      return `
        <tr class="upload__file">
          <td><span class="glyphicon glyphicon-file"></span></td>
          <td class="upload__file__name">
            ${escapeHtml(file.obj.name)}
            ${errorHtml}
          </td>
          <td class="upload__file__size">${filesize(file.obj.size)}</td>
          <td class="upload__file__status">
            ${this.uploading ? `<div class="upload__file__progress">${progress}</div>` : actionsHtml}
          </td>
        </tr>`
    }).join("")

    this.listTarget.innerHTML = `
      <table class="upload__list table table-striped table-condensed table-hover">
        <tbody>${html}</tbody>
      </table>`

    if (this.uploading) {
      this.progressTarget.style.display = ""
    }
  }

  updateProgress() {
    const total = this.files.reduce((sum, f) => {
      return sum + (typeof f.progress === "number" ? f.progress : 0)
    }, 0)
    const percent = parseInt((total / (this.files.length * 100)) * 100)
    this.progressBarTarget.style.width = `${percent}%`
    this.progressBarTarget.setAttribute("aria-valuenow", percent)
  }

  updateButton() {
    const disabled = !this.files.length || this.uploading
    this.buttonTarget.disabled = disabled
    if (disabled) {
      this.buttonTarget.classList.add("disabled")
    } else {
      this.buttonTarget.classList.remove("disabled")
    }
  }

  applyErrors(errors) {
    Object.keys(errors).forEach((key) => {
      const file = this.files.find((f) => {
        const name = f.obj.name.replace(/:/, "-")
        return name === key
      })
      if (file) file.error = errors[key].join(", ")
    })
  }
}

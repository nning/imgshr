import { application } from "./application"

import controllers from "./**/*_controller.js"

controllers.forEach(({ name, module: mod }) => {
  application.register(name, mod.default)
})

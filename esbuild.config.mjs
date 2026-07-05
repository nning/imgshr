import * as esbuild from "esbuild"
import rails from "esbuild-rails"
import path from "path"

const args = process.argv.slice(2)
const watch = args.includes("--watch")

const libsodiumSumoPath = path.resolve(
  "node_modules/libsodium-sumo/dist/modules-sumo-esm/libsodium-sumo.mjs"
)

const libsodiumPlugin = {
  name: "libsodium-resolver",
  setup(build) {
    build.onResolve({ filter: /^\.\/libsodium-sumo\.mjs$/ }, (args) => {
      if (args.importer.includes("libsodium-wrappers-sumo")) {
        return { path: libsodiumSumoPath }
      }
    })
  },
}

const config = {
  absWorkingDir: process.cwd(),
  bundle: true,
  entryPoints: ["app/javascript/application.js"],
  outdir: "app/assets/builds",
  sourcemap: watch,
  format: "esm",
  splitting: true,
  plugins: [rails(), libsodiumPlugin],
  loader: { ".js": "js" },
  chunkNames: "[name]-[hash]",
}

if (watch) {
  const ctx = await esbuild.context(config)
  await ctx.watch()
} else {
  await esbuild.build(config)
}

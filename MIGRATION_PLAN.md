# Migration Plan: React + Webpacker → Hotwire + Stimulus + esbuild

## Branch
`feature/hotwire-stimulus-migration` (based on `main`)

## Current Status: CODE COMPLETE — awaiting manual testing

### What was done

**Phase 1: Build pipeline**
- Replaced `@rails/webpacker` with `jsbundling-rails` + `esbuild`
- Added `turbo-rails`, `stimulus-rails` to Gemfile
- Created `esbuild.config.mjs` with code splitting and `esbuild-rails` plugin
- Created Stimulus controller infrastructure (`app/javascript/controllers/`)
- Renamed Sprockets manifest to `legacy.js` (jQuery, Bootstrap 3, best_in_place, slider, raty)
- Updated layout to load both bundles with `defer`
- Removed CSP `unsafe_eval` and webpack dev server URLs
- Removed `node_modules` from Sprockets asset paths
- `yarn.lock` deleted, `package-lock.json` committed

**Phase 2: Trivial components**
- `Icon.js` → deleted (Rails `icon` helper already existed)
- `ProgressBar.js` → deleted (inline HTML in upload controller)
- `Timestamp.js` → deleted (server-side formatting in `TimestampHelper` with `time_ago_in_words`)
- `AsyncCheckbox.js` → deleted (Stimulus `async_checkbox_controller.js` + `_async_checkbox.html.haml` partial)
- `LazyPicture.js` → deleted (native `loading="lazy"`)
- `ScrollToTopButton.js` → deleted (Stimulus `scroll_to_top_controller.js`)

**Phase 3: Medium components**
- `QRCode.js` → `qr_code_controller.js` (keeps `qrcode` npm package)
- `crypto/EncryptedImage.js` → `encrypted_image_controller.js`
- `crypto/LazyEncryptedImage.js` → merged into `encrypted_image_controller.js`
- `crypto/ClientEncryptionKey.js` → `client_encryption_key_controller.js`
- `Placeholder.js` → deleted (inline HTML in views)
- Sodium: separate webpacker pack → dynamic `import("libsodium-wrappers-sumo")` in `lib/crypto.js`
- Code splitting: libsodium (2.3MB) is a separate chunk loaded only when needed

**Phase 4: Upload system**
- `Upload.js` + `UploadFile.js` + `UploadList.js` + `UploadFileActions.js` → single `upload_controller.js`
- Uses `XMLHttpRequest` for progress events
- Concurrency limit (2) without external library
- Encryption gated by `data-upload-encrypt-value` attribute (gallery's `client_encrypted` flag)
- File list rendered via direct DOM manipulation

**Phase 5: CoffeeScript (partial — legacy bridge kept)**
- `infinite_scrolling.js` → `infinite_scroll_controller.js` (Stimulus, with re-entrancy guard)
- CoffeeScript files (dropdown, tooltips, best_in_place, rating, galleries) → still in `legacy.js`
- Bridge: `application.js` dispatches `content:update` as both CustomEvent and jQuery event
- This keeps jQuery plugins working during transition

**Phase 6: Gem cleanup**
- Removed from Gemfile: `react-rails`, `webpacker`, `local_time`
- Kept: `coffee-rails`, `jquery-rails`, `best_in_place`, `bootstrap-sass` (legacy bridge)
- Kept: `rails-assets-jquery`, `rails-assets-seiyria-bootstrap-slider` (legacy bridge)
- npm: removed all React/webpack/babel/eslint packages (49 → 7 dependencies)

**Infrastructure**
- Dockerfile updated for Node 24 (`deploy/node_setup_24.x.sh`)
- `.nvmrc` updated to `24`
- Volta pinned to Node 24 in `package.json`
- Procfile updated (webpacker → `npm run build -- --watch`)

### Architecture

```
Browser loads 2 JS bundles (both defer):
  1. application.js (338KB) — esbuild bundle: Turbo + Stimulus + controllers
  2. legacy.js (Sprockets) — jQuery + Bootstrap 3 + best_in_place + slider + raty + CoffeeScript

Stimulus controllers (progressive enhancement):
  - scroll_to_top: shows/hide button on scroll
  - async_checkbox: PATCH form on checkbox change
  - qr_code: renders QR to canvas
  - encrypted_image: fetches blob → decrypts → sets as data URL
  - client_encryption_key: shows encryption key + QR + copy
  - upload: file picker + concurrent upload + progress + encryption
  - infinite_scroll: IntersectionObserver triggers fetch

libsodium-wrappers-sumo (2.3MB) is a separate chunk loaded on demand
via dynamic import() — only when encrypted-image or upload controllers
actually need crypto operations.

content:update bridge: application.js dispatches content:update as
both CustomEvent and jQuery event on DOMContentLoaded, turbo:frame-load,
and turbo:render. Legacy CoffeeScript files listen via jQuery.
```

### SSR note

The original project had `server_rendering.js` but NO view used
`prerender: true` (it was commented out in `_upload.html.haml`).
So there was no actual SSR happening. The new Stimulus approach is
progressive enhancement: Rails renders HTML, Stimulus binds on
`data-controller` attributes. No behavior change.

### What still needs manual testing

Before merging, test these features in the browser:

1. **Gallery show page** — pictures render, lazy loading works
2. **Endless scroll** — scrolls to bottom, more pages load (multiple, not just one)
3. **Upload modal** — file selection, file list, upload with progress, upload button enable/disable
4. **Encrypted gallery upload** — files are encrypted before upload (libsodium chunk loads)
5. **Encrypted images** — decrypt and display on gallery show + picture show
6. **AsyncCheckbox** — toggle read_only, ratings_enabled, endless_page, device_links_only
7. **AsyncCheckbox with reload** — toggle responsive_image_service, client_encrypted, ignore_exif_date
8. **QR code** — renders for gallery URL in info modal
9. **Client encryption key** — key displays, QR renders, copy works
10. **Scroll-to-top button** — appears after scrolling 320px, scrolls to top on click
11. **Timestamps** — show relative time ("5 minutes ago") and tooltip with full date
12. **Best-in-place editing** — tag list, gallery name, picture title
13. **Star rating** — renders and submits
14. **Filter slider** — rating range slider works
15. **Dropdowns** — Bootstrap dropdowns work
16. **Tooltips** — Bootstrap tooltips work

### Steps to test

```bash
# 1. Install gems
bundle install

# 2. Install npm packages
npm install

# 3. Build JS
npm run build

# 4. Run the Rails tasks to install Turbo + Stimulus
rails turbo:install stimulus:install

# 5. Start the server
bin/rails s

# 6. In another terminal, start the esbuild watcher (optional, for development)
npm run build -- --watch
```

### Remaining migration work (not blocking)

These are things that could be done later to fully modernize:
- Replace jQuery + Bootstrap 3 with Bootstrap 5 (or Tailwind)
- Migrate CoffeeScript files to Stimulus controllers
- Replace `best_in_place` with Turbo Frame inline editing
- Replace `jquery.raty` with a CSS-only star rating + Stimulus
- Replace `seiyria-bootstrap-slider` with native `<input type="range">`
- Enable Turbo Drive (currently disabled during transition)
- Remove jQuery dependency entirely

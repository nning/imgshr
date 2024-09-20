// Entry point for the build script in your package.json
import ReactRailsUJS from 'react_ujs'

// Support component names relative to this directory:
const componentRequireContext = require.context('./components', true)
ReactRailsUJS.useContext(componentRequireContext)

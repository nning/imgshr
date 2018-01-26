import ReactRailsUJS from 'react_ujs'

// Support component names relative to this directory:
const componentRequireContext = require.context('components/global', true)
ReactRailsUJS.useContext(componentRequireContext)

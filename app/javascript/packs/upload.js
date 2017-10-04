import ReactRailsUJS from 'react_ujs';

// Support component names relative to this directory:
const componentRequireContext = require.context('components', true)
ReactRailsUJS.useContext(componentRequireContext)

import '../components/Upload.jsx'

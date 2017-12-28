import ReactRailsUJS from 'react_ujs'

// Support component names relative to this directory:
const componentRequireContext = require.context('components', true)
ReactRailsUJS.useContext(componentRequireContext)

import '../components/AsyncCheckbox.jsx'
import '../components/QRCode.jsx'
import '../components/ScrollToTopButton.jsx'
import '../components/Upload.jsx'

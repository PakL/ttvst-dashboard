const path = require("path")
const UIPage  = require(path.dirname(module.parent.filename) + '/../mod/uipage')
const fs = require('fs')

class Dashboard extends UIPage {

	constructor(tool, i18n) {
		super('Dashboard')

		const self = this
		this._tool = tool
		this._i18n = i18n
		this._view = document.createElement('dashboardframe')
		this._contentElement = document.createElement('div')
		this._contentElement.appendChild(this._view)

		let dashboardframeTag = fs.readFileSync(__dirname.replace(/\\/g, '/') + '/res/dashboardframe.tag', { encoding: 'utf8' })
		let {code} = riot.compileFromString(dashboardframeTag)
		riot.inject(code, 'dashboardframe', __dirname.replace(/\\/g, '/') + '/res/dashboardframe.tag')

		document.querySelector('#contents').appendChild(this._contentElement)
		riot.mount(this._view, { addon: this })
	}

	open() {
		this._contentElement.style.display = 'block'
		if(typeof(this._tool.cockpit.openChannelObject.login) === 'string') {
			this._view._tag.openDashboard(this._tool.cockpit.openChannelObject.login)
		} else {
			this._view._tag.openDashboard(this._tool.auth.username)
		}
	}

	close() {
		this._contentElement.style.display = 'none'
		this._view._tag.clearDashboard()
	}

	get icon() {
		return '🚦'
	}
}
module.exports = Dashboard
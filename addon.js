"use strict"

const path = require("path")
const {spawn} = require('child_process')
const UIPage  = require(path.dirname(module.parent.filename) + '/../mod/uipage')
const fs = require('fs')

class Analytics extends UIPage {

	constructor(tool, i18n) {
		super('Analytics')

		const self = this
		this._tool = tool
		this._i18n = i18n
		this._view = document.createElement('anaframe')
		this._contentElement = document.createElement('div')
		this._contentElement.appendChild(this._view)

		this._tool.on('load', () => {

			document.querySelector('#contents').appendChild(self._contentElement)

			
			riot.compile('/' + __dirname.replace(/\\/g, '/') + '/res/anaframe.tag', () => {
				riot.mount(self._view)
			})
			
		})
	}

	open() {
		this._contentElement.style.display = 'block'
		this._view._tag.open_stats(this._tool.auth.username)
	}

	close() {
		this._contentElement.style.display = 'none'
	}
}
module.exports = Analytics
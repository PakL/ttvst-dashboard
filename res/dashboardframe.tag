<dashboardframe>
	<webview src="about:blank" border="0"></webview>

	<style>
		dashboardframe {
			display: block;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		dashboardframe > webview {
			width: 100%;
			height: 100%;
			border: 0;
		}
	</style>
	<script>
		const {shell} = require('electron')
		export default {
			onBeforeMount() {
				this._username = ''
				this.frame = null
				this.addon = this.props.addon
				this.makeAccessible()
			},

			onMounted() {
				const self = this
				this.frame = this.root.querySelector('webview')
				this.frame.addEventListener('did-finish-load', () => { self.pagechange() })
				if(this._username.length > 0) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/')
				}
				this.frame.addEventListener('new-window', (e) => {
					if(e.disposition != 'save-to-disk') {
						shell.openExternal(e.url)
					}
				})
				this.frame.addEventListener('did-start-loading', (e) => {
					Tool.ui.startLoading(this.addon)
				})
				this.frame.addEventListener('did-stop-loading', (e) => {
					Tool.ui.stopLoading(this.addon)
					self.stoppedLoading()
				})
			},

			openDashboard(username) {
				this._username = username
				if(this.frame !== null) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/')
				}
			},

			clearDashboard() {
				if(this.frame !== null) {
					this.frame.loadURL('about:blank')
				}
			},

			stoppedLoading() {
				let webcontent = this.frame.getWebContents()
				webcontent.executeJavaScript('\
					var expandViewBtn = document.querySelector(".tw-block.tw-border-radius-rounded.tw-full-width.tw-interactable.tw-interactable--base.tw-interactable--border.tw-interactive");\
					expandViewBtn.click();\
					expandViewBtn.blur();\
					expandViewBtn.remove();\
				')
			},

			pagechange() {
				let location = this.frame.getURL()
				console.log('[Dashboard]' + location)

				if(location.length <= 0 || location == 'about:blank') return
				if(!location.startsWith('https://passport.twitch.tv/') && !location.startsWith('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/')) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username + '/dashboard/')
				}
				
				let webcontent = this.frame.getWebContents()
				webcontent.insertCSS('\
						/*.top-nav,\
						.dashboard-side-nav,\
						.ca-welcome-modal,\
						.tw-tooltip-wrapper,*/\
						div[data-test-selector=drag-and-drop-popout-button]\
						{ display: none !important; }\
				')
				webcontent.executeJavaScript('\
					document.querySelector("html").classList.add("tw-root--theme-dark");\
				')
			}
		}
	</script>
</dashboardframe>
<anaframe>
	<webview src="about:blank" border="0"></webview>

	<style>
		anaframe {
			display: block;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		anaframe > webview {
			width: 100%;
			height: 100%;
			border: 0;
		}
	</style>
	<script>
		const self = this
		this._username = ''

		let frame = null

		this.on('mount', () => {
			frame = self.root.querySelector('webview')
			frame.addEventListener('did-finish-load', () => { self.pagechange() })
			if(self._username.length > 0) {
				frame.loadURL('https://www.twitch.tv/' + self._username + '/dashboard/stats')
			}
		})

		open_stats(username) {
			self._username = username
			if(frame !== null) {
				frame.loadURL('https://www.twitch.tv/' + username + '/dashboard/stats')
			}
		}

		pagechange() {
			let location = frame.getURL()
			console.log(location)

			if(location.length <= 0) return
			if(!location.startsWith('https://passport.twitch.tv/') && !location.startsWith('https://www.twitch.tv/' + self._username.toLowerCase() + '/dashboard/stats')) {
				frame.loadURL('https://www.twitch.tv/' + self._username + '/dashboard/stats')
			}
			
			let webcontent = frame.getWebContents()
			webcontent.insertCSS('\
div.app-main { top: 0 !important; color:#fff !important; background: ' + window.getComputedStyle(document.querySelector("body")).getPropertyValue('background-color') + ' !important; }\
nav.top-nav { display: none !important; }\
nav.vod-vertical-nav { display: none !important; }\
.dashboard-page > .full-width { margin-left: 0 !important; }\
.conversations-list-icon { display: none !important; }\
.brick--theme-grey.brick { display: none !important; }\
')
			webcontent.executeJavaScript('document.querySelector("body").classList.add("theme--dark"); setTimeout(() => { document.querySelectorAll("a.button")[0].style.display="none"; }, 2000);')
		}

	</script>
</anaframe>
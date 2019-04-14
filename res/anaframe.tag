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

		const {shell} = require('electron')

		this.on('mount', () => {
			frame = self.root.querySelector('webview')
			frame.addEventListener('did-finish-load', () => { self.pagechange() })
			if(self._username.length > 0) {
				frame.loadURL('https://www.twitch.tv/' + self._username.toLowerCase() + '/dashboard/channel-analytics')
			}
			frame.addEventListener('new-window', (e) => {
				if(e.disposition != 'save-to-disk') {
					shell.openExternal(e.url)
				}
			})
		})

		open_stats(username) {
			self._username = username
			if(frame !== null) {
				frame.loadURL('https://www.twitch.tv/' + self._username.toLowerCase() + '/dashboard/channel-analytics')
			}
		}

		pagechange() {
			let location = frame.getURL()
			console.log(location)

			if(location.length <= 0) return
			if(!location.startsWith('https://passport.twitch.tv/') && !location.startsWith('https://www.twitch.tv/' + self._username.toLowerCase() + '/dashboard/channel-analytics')) {
				frame.loadURL('https://www.twitch.tv/' + self._username + '/dashboard/channel-analytics')
			}
			
			let webcontent = frame.getWebContents()
			webcontent.insertCSS('\
					.top-nav { display: none !important; }\
					.dashboard-side-nav { display: none !important; }\
			')
			webcontent.executeJavaScript('\
				document.querySelector("html").classList.add("tw-root--theme-dark");\
				setTimeout(() => { document.querySelectorAll("a.button")[0].style.display="none"; }, 2000);\
			')
		}

	</script>
</anaframe>
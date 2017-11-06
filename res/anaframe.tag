<anaframe>
	<iframe src="" border="0" onload={pagechange}></iframe>

	<style>
		anaframe {
			display: block;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		anaframe > iframe {
			width: 100%;
			height: 100%;
			border: 0;
		}
	</style>
	<script>
		const self = this
		this._username = ''
		open_stats(username) {
			self._username = username
			self.root.querySelector('iframe').src = 'https://www.twitch.tv/' + username + '/dashboard/stats'
		}

		pagechange() {
			let frame = self.root.querySelector('iframe').contentDocument
			let location = frame.location.href.toLowerCase()
			if(location.length <= 0 || location == 'about:blank') return
			if(!location.startsWith('https://passport.twitch.tv/') && !location.startsWith('https://www.twitch.tv/' + self._username.toLowerCase() + '/dashboard/stats')) {
				self.root.querySelector('iframe').src = 'https://www.twitch.tv/' + self._username + '/dashboard/stats'
			}
			let styleelement = frame.createElement('style')
			styleelement.type = "text/css"
			styleelement.innerHTML = '\
html { filter: invert(100%); }\
div.app-main { top: 0 !important; background: #faf9fa; }\
nav.top-nav { display: none !important; }\
nav.vod-vertical-nav { display: none !important; }\
.dashboard-page > .full-width { margin-left: 0 !important; }\
.conversations-list-icon { display: none !important; }\
.brick--theme-grey.brick { display: none !important; }\
'
			frame.querySelector('head').appendChild(styleelement)

		}
	</script>
</anaframe>
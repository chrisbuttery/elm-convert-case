var tag = document.createElement('script')
tag.src = 'https://www.youtube.com/iframe_api'

var firstScriptTag = document.getElementsByTagName('script')[0]
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

var player
var display
var done = false

var videos = [
	{'videoId': 'pElSu_ECJGM', 'startSeconds': 0, 'endSeconds': 95, 'suggestedQuality': 'hd720'},
	{'videoId': 'ZxlJxDr26mM', 'startSeconds': 12, 'endSeconds': 82, 'suggestedQuality': 'hd720'},
	{'videoId': 'ariuokNFhSw', 'startSeconds': 30, 'endSeconds': 174, 'suggestedQuality': 'hd720'},
	{'videoId': 'Lw0FP9putKM', 'startSeconds': 15, 'endSeconds': 194, 'suggestedQuality': 'hd720'},
  {'videoId': 'NG3-GlvKPcg', 'startSeconds': 0, 'endSeconds': 101, 'suggestedQuality': 'hd720'}
]

var randomVideo = Math.floor(Math.random() * videos.length)
var currentVideo = randomVideo

var playerDefaults = {
	autohide: 1,
	autoplay: 0,
	controls: 0,
	disablekb: 1,
	enablejsapi: 0,
	iv_load_policy: 3,
	modestbranding: 0,
	rel: 0,
	showinfo: 0
}

function onYouTubeIframeAPIReady () {
  player = new YT.Player('player', {
    events: {
      'onReady': loadPlayer,
      'onStateChange': onPlayerStateChange
    },
    playerVars: playerDefaults
  })
}

function loadPlayer () {
  if (!display) display = document.querySelector('.js-display')
	console.log('currentVideo', currentVideo)
  player.loadVideoById(videos[currentVideo])
  player.seekTo(videos[currentVideo].startSeconds)
  player.mute()
  videoRescale()
}

function onPlayerStateChange (e) {
  if (e.data === 1) {
    done = true
    display.classList.add('active')
  } else {
    if (done) {
      display.classList.remove('active')
      if (currentVideo === videos.length - 1) {
        currentVideo = 0
      } else {
        currentVideo++
      }
      done = false
      loadPlayer()
    }
  }
}

function videoRescale () {
  if (!player) return
  var w = window.innerWidth
  var h = window.innerHeight
  if ((w / h) > (16 / 9)) {
    player.setSize(w, w / 16 * 9)
  } else {
    player.setSize(h / 9 * 16, h)
  }
}

window.addEventListener('resize', videoRescale)

var clipboard = new Clipboard('.trigger')
var parent
clipboard.on('success', function (e) {
  parent = e.trigger.parentElement
  parent.classList.add('success')
  e.clearSelection()
  setTimeout(function () {
    parent.classList.remove('success')
  }, 250)
})

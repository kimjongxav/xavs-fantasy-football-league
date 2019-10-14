function hamburger() {
  var x = document.getElementById('menu-links')

  if (x.style.display === 'block') {
    x.style.display = 'none'
  } else {
    x.style.display = 'block'
  }
}

function stadiumSwitcher() {
  var thingsToHide = document.querySelectorAll('.mobile-visible')
  var thingsToShow = document.querySelectorAll('.mobile-hidden')

  thingsToHide.forEach(element => {
    element.classList.remove('mobile-visible')
    element.classList.add('mobile-hidden')
  })

  thingsToShow.forEach(element => {
    element.classList.remove('mobile-hidden')
    element.classList.add('mobile-visible')
  })

  var thingsToHighlight = document.querySelectorAll('.highlighted')
  var thingsToUnhighlight = document.querySelectorAll('.unhighlighted')

  thingsToHighlight.forEach(element => {
    element.classList.remove('highlighted')
    element.classList.add('unhighlighted')
  })

  thingsToUnhighlight.forEach(element => {
    element.classList.remove('unhighlighted')
    element.classList.add('highlighted')
  })
}

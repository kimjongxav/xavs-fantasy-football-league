function hamburger() {
  const x = document.getElementById('menu-links')

  if (x.style.display === 'block') {
    x.style.display = 'none'
  } else {
    x.style.display = 'block'
  }
}

function stadiumSwitcher() {
  const thingsToHide = document.querySelectorAll('.mobile-visible')
  const thingsToShow = document.querySelectorAll('.mobile-hidden')

  thingsToHide.forEach(element => {
    element.classList.remove('mobile-visible')
    element.classList.add('mobile-hidden')
  })

  thingsToShow.forEach(element => {
    element.classList.remove('mobile-hidden')
    element.classList.add('mobile-visible')
  })

  const thingsToHighlight = document.querySelectorAll('.highlighted')
  const thingsToUnhighlight = document.querySelectorAll('.unhighlighted')

  thingsToHighlight.forEach(element => {
    element.classList.remove('highlighted')
    element.classList.add('unhighlighted')
  })

  thingsToUnhighlight.forEach(element => {
    element.classList.remove('unhighlighted')
    element.classList.add('highlighted')
  })
}

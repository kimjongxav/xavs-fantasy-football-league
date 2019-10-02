function hamburger() {
  const x = document.getElementById('menu-links')

  if (x.style.display === 'block') {
    x.style.display = 'none'
  } else {
    x.style.display = 'block'
  }
}

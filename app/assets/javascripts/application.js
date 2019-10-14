// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require chartkick
//= require Chart.bundle

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

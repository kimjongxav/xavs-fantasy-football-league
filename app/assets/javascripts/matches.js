function stadiumSwitcher() {
    const thingsToHide = document.querySelectorAll('.mobile-visible')
    const thingsToShow = document.querySelectorAll('.mobile-hidden')

    thingsToHide.forEach(element => {
        element.classList.remove('mobile-visible')
        element.classList.add('mobile-hidden')    
    });

    thingsToShow.forEach(element => {
        element.classList.remove('mobile-hidden')
        element.classList.add('mobile-visible')    
    });
}

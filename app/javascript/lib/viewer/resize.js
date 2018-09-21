

export default (contentElem, sidebarElem, query = false) => {
  if (query) {
    contentElem.attr('class', 'col-md-7')
    sidebarElem.attr('class', 'col-md-5')
  } else {
    contentElem.attr('class', 'col-md-8')
    sidebarElem.attr('class', 'col-md-4')
  }
}
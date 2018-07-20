$( document ).on('turbolinks:load', function() {
  $('.details-pill a').click(function(event) {
    event.preventDefault();
    $('.details-pill').addClass('active');
    $('.citation-pill').removeClass('active');
    $('.item-metadata .citation').addClass('hide');
    $('.item-details .citation').removeClass('hide');
  });
  $('.citation-pill a').click(function(event) {
    event.preventDefault();
    $('.details-pill').removeClass('active');
    $('.citation-pill').addClass('active');
    $('.item-metadata .citation').removeClass('hide');
    $('.item-details .citation').addClass('hide');
  });
});
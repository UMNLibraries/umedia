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
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

function noThumbnail(document_id, original_url) {
  // Wait for the JS stack to clear before running our searches
  setTimeout(cacheThumbnail.bind(null, document_id, original_url), 0);
  return original_url;
}

function cacheThumbnail(document_id, original_url) {
  console.log(`Caching thumbnail image for document ${document_id} located at: ${original_url}`);
  $.get('/thumbnails/'.concat(document_id));
}
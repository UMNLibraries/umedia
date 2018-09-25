var noThumbnail = function(item_id, original_url) {
  console.log(`Caching thumbnail image for document ${item_id} located at: ${original_url}`);
  $.get('/thumbnails/'.concat(item_id));
  return original_url;
}

function cacheThumb(item_id) {
  $.get('/thumbnails/'.concat(item_id));
}

window.noThumbnail = noThumbnail;

export default noThumbnail;

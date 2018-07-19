var noThumbnail = function(document_id, original_url) {
  console.log(`Caching thumbnail image for document ${document_id} located at: ${original_url}`);
  $.get('/thumbnails/'.concat(document_id));
  return original_url;
}

window.noThumbnail = noThumbnail;

export default noThumbnail;

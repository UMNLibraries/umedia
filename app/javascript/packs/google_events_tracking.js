$( document ).on('turbolinks:load', function() {

  function serialize_event_value(data) {
    return data + '|' + window.location.hostname + '|' + window.location.pathname
  }

  function ga_event(category, action, label) {
    ga('send', {
      hitType: 'event',
      eventCategory: category,
      eventAction:  action,
      eventLabel: serialize_event_value(label)
    });
  }

  // Header
  $('.navbar-brand a').click(function(e) {
    ga_event('Header', 'Brand', $(this).text());
  });

  $('li.about-link a').click(function(e) {
    ga_event('Header', 'Help Links', 'about');
  });

  $('li.contact-link a').click(function(e) {
    ga_event('Header', 'Help Links', 'contact');
  });

  // Search
  $('.main-search .search-btn').click(function(e) {
    ga_event('Search', 'Submit', $('#q').val());
  });

  $('a.json-search-link').click(function(e) {
    ga_event('Search', 'JSON', $('#q').val());
  });




  // Facets
  $('a.collection-browse-link').click(function(e) {
    ga_event('Search', 'Collection Browse', 'click');
  });

  $('a.type-browse-link').click(function(e) {
    ga_event('Search', 'Type Browse', 'click');
  });

  $('a.format-browse-link').click(function(e) {
    ga_event('Search', 'Format Browse', 'click');
  });

  $('a.date-browse-link').click(function(e) {
    ga_event('Search', 'Date Browse', 'click');
  });

  $('a.subject-browse-link').click(function(e) {
    ga_event('Search', 'Subject Browse', 'click');
  });

  $('a.contributing-org-browse-link').click(function(e) {
    ga_event('Search', 'Contrib Org Browse', 'click');
  });

  // Facets
  $('.panel-super_collection_name_ss a').click(function(e) {
    ga_event('Facet', 'Special Projects', $(this).text());
  });

  $('.panel-collection_name_s a').click(function(e) {
    ga_event('Facet', 'Collection', $(this).text());
  });

  $('.panel-types a').click(function(e) {
    ga_event('Facet', 'Type', $(this).text());
  });

  $('.panel-format_name a').click(function(e) {
    ga_event('Facet', 'Format', $(this).text());
  });

  $('.panel-date_created_ss a').click(function(e) {
    ga_event('Facet', 'Date Created', $(this).text());
  });

  $('.panel-subject_ss a').click(function(e) {
    ga_event('Facet', 'Subject', $(this).text());
  });

  $('.panel-creator_ss a').click(function(e) {
    ga_event('Facet', 'Creator', $(this).text());
  });

  $('.panel-contributor_ss a').click(function(e) {
    ga_event('Facet', 'Contributor', $(this).text());
  });

  $('.panel-publisher_s a').click(function(e) {
    ga_event('Facet', 'Publisher', $(this).text());
  });

  $('.panel-language a').click(function(e) {
    ga_event('Facet', 'Language', $(this).text());
  });



  // Full Record
  $('a.back-to-search-link').click(function(e) {
    ga_event('Full Record', 'Back to Search', $(this).text());
  });

  $('a.large-download').click(function(e) {
    ga_event('Full Record', 'Large Download Button', $(this).text());
  });

  $('.metadata-nav a').click(function(e) {
    ga_event('Full Record', 'Metadata Nav', $(this).text());
  });

  $('#sidebar button').click(function(e) {
    ga_event('Sidebar', 'Search', $('#sidebar #q').val());
  });

  $('a.sidebar-page').click(function(e) {
    ga_event('Sidebar', 'Page', ($(this).find('h4')[0].textContent));
  });

});
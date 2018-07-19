/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

import "jquery"
import "jquery-ujs"
import "bootstrap-sass"
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

document.addEventListener("DOMContentLoaded",function(){
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
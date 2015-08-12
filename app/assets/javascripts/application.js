// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require materialize-sprockets
//= require cocoon
//= require_tree .

$(function(){
  $('.datepicker').pickadate({
   selectMonths: false,
   selectYears: false,
   format: 'dddd, mmmm d, yyyy'
  });

  var userAgent = window.navigator.userAgent;
  if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i)) {
    $('select:not(.browser-default)').addClass('browser-default');
  }
  $('select:not(.browser-default)').material_select();
});

$(document).on('click', 'input[type=text][for]',function(){
  $(['input[id="',$(this).attr('for'),'"]'].join('')).click();
});

$(document).on('click', '.stop-propagation', function(event){
  event.stopPropagation();
});

$(document).on('click', '.prevent-default', function(event){
  event.preventDefault();
});

$(document).on('click', 'input[data-trigger-form]', function(event){
  event.preventDefault();
  $(this).prop('checked',true);
  form = $(this.form);
  form.addClass('no-pointer-events');
  form.submit();
});

$(document).on('click', 'form button[data-submit]', function(){
  $t = $(this);
  $f = $t.closest('form');
  $f.submit();
});

function deletePoll(ele,event) {
  event.preventDefault();
  $t = $(ele);
  parent = $t.parent();
  if ($t.text() == 'Delete') {
    $t.text('Restore');
    parent.addClass('deleted-option')
    parent.children('input:hidden').first().value('1')
  } else {
    $t.text('Delete');
    parent.removeClass('deleted-option')
    parent.children('input:hidden').first().value('0')
  }
}

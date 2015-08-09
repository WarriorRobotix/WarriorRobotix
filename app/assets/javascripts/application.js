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
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function(){
  $('input[type=text][for]').click(function(){
    $(['input[id="',$(this).attr('for'),'"]'].join('')).click();
  });

  $('table[data-row-trigger-input] tr').click(function(){
    $(this).find('input[type=radio],input[type=checkbox]').first().click();
  });

  $('.stop-propagation').click(function(event){
    event.stopPropagation();
  });

  $('input[data-trigger-form]').click(function(event){
    event.preventDefault();
    $(this).prop('checked',true);
    form = $(this.form);
    form.addClass('no-pointer-events');
    form.submit();
  });
})

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

Turbolinks.enableProgressBar();

$(function(){
  if (window.is_ios()) { window.ios_ready(); }
  window.hash_modal.refresh();

  $('.datepicker').pickadate({
   selectMonths: true,
   selectYears: false,
   format: 'dddd, mmmm d, yyyy'
  });

  $('select:not(.browser-default)').material_select();

  $('ul.tabs').tabs();

  replceNullDisableWith();

  $('.button-collapse').sideNav();

  $('.materialboxed').materialbox();

  $('.slider').each(function(){
    var t = $(this);
    var options = {full_width: true};
    options['height'] = t.data('height') || Math.max(400, ~~(t.parent().width() / 2.5));
    if (typeof t.data('vh-minus') != 'undefined'){
      var vheight = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0);
      vheight -= parseInt(t.data('vh-minus'));
      options['height'] = Math.max(Math.min(options['height'], vheight), 300);
    }
    t.slider(options);
  });

  $('.fixed-action-btn').openFAB();

  $('.countdown').countdown();

  $(".dropdown-button").dropdown();
});

$(window).on('hashchange', function(){
  window.hash_modal.hashchange();
});

$(document).on('click', 'input[type=text][for]',function(){
  $(['input[id=\"',$(this).attr('for'),'\"]'].join('')).click();
});

$(document).on('click', '.stop-propagation', function(event){
  event.stopPropagation();
});

$(document).on('click', '.prevent-default', function(event){
  event.preventDefault();
});

$(document).on('click', 'input[data-trigger-form]', function(event){
  event.preventDefault();
  $t = $(this);
  if ($t.attr('type') == 'checkbox') {
    $t.prop('checked',!$t.prop('checked'));
  } else {
    $t.prop('checked',true);
  }
  form = $(this.form);
  form.addClass('no-pointer-events');
  form.submit();
});

$(document).on('change', '.file-field input[type=\"file\"][data-photo-name-target]', function () {
  $t = $(this);
  var form = $t.closest('form');
  var target = form.find($t.data('photo-name-target'));
  if ($t[0].files !== undefined || $t[0].files[0] !== undefined) {
    var file = $t[0].files[0].name.replace(/\.[^/.]+$/, '');
    form.find(['label[for=\"',$t.data('photo-name-target').slice(1),'\"]'].join('')).addClass('active');
    target.attr('placeholder',file);
  }
});

$(document).on('change', '.post-restriction select', function () {
  var $t = $(this);
  var newVal = $t.val();
  var limitedTeamsRow = $t.closest('form').find('.post-limited-teams');
  if (newVal == 'limited'){
    limitedTeamsRow.css({'display':'block'});
  } else {
    limitedTeamsRow.css({'display':'none'});
  }
});



$(document).ready(function(){
  $('.modal-switch').leanModal();
});


$(document).on('click', '.lean-overlay', function(){
  location.hash = '#!';
});

$(document).on('click', '.data-modal-trigger', function(event){
  event.preventDefault;

  var t = $(this);
  var modal = $(['#', t.data('modal-target'), '.modal'].join('')).first();
  if (modal.length){
    var fillData = t.data('modal-fill');
    if (typeof fillData === "object"){
      for (key in fillData){
        value = fillData[key];
        modal.find(['span[data-fill=\"', key ,'\"]'].join('')).html(value)
        modal.find(['input[data-fill=\"', key ,'\"]'].join('')).val(value)
      }
    }
    modal.openModal();
  }
});

$(document).on('click', '.read-more-box .read-more .button', function() {

  var totalHeight = 0

  var $el = $(this);
  var $p  = $el.parent();
  var $up = $p.parent();
  var $ps = $up.children("p:not('.read-more')");

  $ps.each(function() {
    totalHeight += $(this).outerHeight();
  });

  $up
    .css({
      "height": $up.height(),
      "max-height": 9999
    })
    .animate({
      "height": totalHeight
    }, 400, 'swing', function(){
      var $t = $(this);
      $t.addClass('expended');
      $t.css({"height": "","max-height": ""});
    });
  $p.fadeOut();
  return false;
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

function replceNullDisableWith(){
  $('input[data-disable-with=\"null\"]').each(function(){
    var t = $(this);
    var v = t.val();
    t.data('disable-with',v)
    t.attr('data-disable-with',v);
  });
}

function enableForm(){
  $('form input[data-enable-by-recaptcha]').prop('disabled', false);
}

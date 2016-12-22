$(function(){
  $(".dropdown-button").dropdown();
  $(".button-collapse").sideNav();

$('#submit_logo').on('click', function() {
  console.log($('input[name="logo_url"]').val());
    $("#team_logo").attr("src", $('input[name="logo_url"]').val());
});

});


$(document).ready(function() {
 $('select').material_select();
 $('#bio').val('');
 $('textarea#bio').trigger('autoresize');
 $('textarea#bio').characterCounter();
 Materialize.updateTextFields();
});

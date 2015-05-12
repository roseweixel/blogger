$(function(){
  $('#new_user').hide();
  $('.toggle-off').hide();

  $('.toggle-on').click(function(){
    $('.toggle-on').hide();
    $('#new_user').slideDown();
    $('.toggle-off').show();
  });

  $('.toggle-off').click(function(){
    $('.toggle-off').hide();
    $('#new_user').slideUp();
    $('.toggle-on').show();
  });
});

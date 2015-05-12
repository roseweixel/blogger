$(function(){
  $('#new_student').hide();
  $('.toggle-off').hide();

  $('.toggle-on').click(function(){
    $('.toggle-on').hide();
    $('#new_student').slideDown();
    $('.toggle-off').show();
  });

  $('.toggle-off').click(function(){
    $('.toggle-off').hide();
    $('#new_student').slideUp();
    $('.toggle-on').show();
  });
});

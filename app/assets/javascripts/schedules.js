$(function(){
  if ($('a[rotation_locked=true]').length > 0) {
    $('#generate').addClass('disabled');
  } else {
    $('#generate').removeClass('disabled');
  }
})

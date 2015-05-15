$(function(){
  $('#hidden-blog-form').hide();
  $('#toggle-blog-form').click(function(e){
    e.preventDefault();
    $('#hidden-blog-form').fadeToggle();
  });
});

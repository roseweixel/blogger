$(function(){
  $('#hidden-blog-form').hide();
  $('#toggle-blog-form').click(function(e){
    e.preventDefault();
    e.stopPropagation();
    $('#hidden-blog-form').fadeToggle();
  });
});

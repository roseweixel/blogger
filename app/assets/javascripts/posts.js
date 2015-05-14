$(function(){
  $.expr[":"].contains = $.expr.createPseudo(function(arg) {
    return function( elem ) {
      return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
  });

  $('#query').on('keyup', function(){
    var query = this.value
    $('.post-title:not(:contains('+query+'))').parent().hide();
    $('.post-title:contains('+query+')').parent().show();
  })
});

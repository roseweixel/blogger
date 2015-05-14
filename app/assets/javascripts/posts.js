$(function(){
  $.expr[":"].contains = $.expr.createPseudo(function(arg) {
    return function( elem ) {
      return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
  });

  $('#query').on('keyup', function(){
    var query = this.value;
    var searchAttribute = $('#search_options').val().match(/\w+$/)[0];
    $('.post-' + searchAttribute + ':not(:contains(' + query + '))').parent().hide();
    $('.post-' + searchAttribute + ':contains(' + query + ')').parent().show();
  });
});

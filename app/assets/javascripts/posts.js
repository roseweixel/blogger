$(function(){
  $.expr[":"].contains = $.expr.createPseudo(function(arg) {
    return function( elem ) {
      return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
    };
  });

  $('#query').on('keyup', function(){
    var query = this.value;
    var searchAttribute = $('#search_options').val().match(/\w+$/)[0];
    $('.post-' + searchAttribute + ':not(:contains(' + query + '))').closest('.post').hide();
    $('.post-' + searchAttribute + ':contains(' + query + ')').closest('.post').show();
  });

  var images = $('img').add('iframe');

  $.each(images, function(index, image) {
    if ($(image).parent().width() > $(image).parent().parent().width()) {
      var parentWidth = $(image).parent().parent().width();
    } else {
      var parentWidth = $(image).parent().width();
    }

    $(image).width(parentWidth);
  });
});
(function() {
  'use strict';
  $(function() {
    $('.lang-html').each(function() {
      var $fdoc, $iframe, $this;
      $this = $(this);
      $iframe = $('<iframe></iframe>');
      $this.parent().before($iframe);
      $fdoc = $iframe.contents();
      $fdoc.find('body').html($this.text());
      return $fdoc.find('head').append('<link rel="stylesheet" href="css/main.css">');
    });
    return prettyPrint();
  });

}).call(this);

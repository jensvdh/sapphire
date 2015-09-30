$(document).ready(function() {
  $('#thread-test').click(function(event) {
    event.stopPropagation();

    $('#thread-test-row .col-lg-12').empty();

    var image = new Image();
    image.src = "/images/really-big-image.png"

    $('#thread-test-row .col-lg-12').append('<p>Image retrieval started, beginning file retrieval.</p>');
    $(image).load(function(){
      $('#thread-test-row .col-lg-12').append('<p>Image loaded</p>');
    });

    $('#thread-test-row .col-lg-12').append('<p>Started requesting JSON files.</p>');

    $([1,2,3,4,5,6,7,8,9,10]).each(function(){
      var number = this;
      $.getJSON("/test/" + number + ".json", function(data) {
        $('#thread-test-row .col-lg-12').append('<p>' + data.value + ' returned.</p>');
      });
    });
  });
});

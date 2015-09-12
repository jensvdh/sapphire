$(document).ready(function() {
  $('#thread-test').click(function(event) {
    event.stopPropagation();

    $('#thread-test-row .col-lg-8').empty();

    var img = $('<img></img>')
      .attr('style', 'height:30px;width:30px;')
      .attr('src', '/images/really-big-image.png')
      .appendTo('#thread-test-row .col-lg-8');

    $('#thread-test-row .col-lg-4 p').text('Image retrieval started, beginning file retrieval.');

    $([1,2,3,4,5,6,7,8,9,10]).each(function(){
      var number = this;
      $.getJSON("/test/" + number + ".json", function(data) {
        $('#thread-test-row .col-lg-4').append('<p>' + data.value + ' returned.</p>');
      });
    });
  });
});

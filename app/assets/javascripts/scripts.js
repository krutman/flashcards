$(function() {
  $(".datetimepicker").datetimepicker();
});

$(function() {
  $('.pagination .disabled a, .pagination .active a').on('click', function(e) {
    e.preventDefault();
  });
});

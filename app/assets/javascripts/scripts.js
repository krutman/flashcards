$(function() {
  $('.datetimepicker').datetimepicker();
  
  $('.pagination .disabled a, .pagination .active a').on('click', function(e) {
    e.preventDefault();
  });
});

#= require bootstrap-carousel
#= require bootstrap-modal

jQuery ->
  $(".carousel").carousel interval: 3000
  $("#myModal").modal show: false
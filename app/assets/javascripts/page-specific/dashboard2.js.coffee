#= require jquery.peity

$(document).ready ->
  $(".peity .bar").peity "bar",
    width: "50",
    height: "30",
    colours: ["#a86156", "#d4c62f", "#97a116"]
    
  $(".peity .pie").peity "pie",
    diameter: "30",
    colours: ["#d4c62f", "fefefe"]
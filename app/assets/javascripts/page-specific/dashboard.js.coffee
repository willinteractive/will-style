#= require ../flot_inits

$(document).ready ->
  graphData = [
    data: [[6, 1300], [7, 1600], [8, 1900], [9, 2100], [10, 2500], [11, 2200], [12, 2000], [13, 1950], [14, 1900], [15, 2000]]
    label: "Visitors"
  ,
    data: [[6, 500], [7, 600], [8, 550], [9, 600], [10, 800], [11, 900], [12, 800], [13, 850], [14, 830], [15, 1000]]
    label: "Returning Visitors"
  ]
  $.plot $("#graph-lines"), graphData,
    series:
      points:
        show: true
        radius: 5

      lines:
        show: true

      shadowSize: 0

    grid:
      color: "#646464"
      borderColor: "transparent"
      borderWidth: 10
      hoverable: true

    xaxis:
      tickColor: "transparent"
      tickDecimals: 0

    yaxis:
      tickSize: 1000

  $.plot $("#graph-bars"), graphData,
    series:
      bars:
        show: true
        barWidth: .9
        align: "center"

      shadowSize: 0

    grid:
      color: "#646464"
      borderColor: "transparent"
      borderWidth: 10
      hoverable: true

    xaxis:
      tickColor: "transparent"
      tickDecimals: 0

    yaxis:
      tickSize: 1000

  $.plot $("#graph-pie"), graphData,
    series:
      pie:
        show: true

  pieData = [
    label: "%78.75 New Visitor"
    data: 78.75
  ,
    label: "%21.25 Returning Visitor"
    data: 21.25
  ]
  $.plot $("#graph-pie"), pieData,
    series:
      pie:
        show: true
        highlight:
          opacity: 0.1

        stroke:
          color: "#fff"
          width: 3

        startAngle: 2

    legend:
      position: "ne"

    grid:
      hoverable: true
      clickable: true

  $("#graph-bars").hide()
  $("#lines").click ->
    $("#bars").removeClass "active"
    $("#graph-bars").fadeOut()
    $(this).addClass "active"
    $("#graph-lines").fadeIn()
    e.preventDefault()

  $("#bars").click ->
    $("#lines").removeClass "active"
    $("#graph-lines").fadeOut()
    $(this).addClass "active"
    $("#graph-bars").fadeIn().removeClass "hidden"
    e.preventDefault()

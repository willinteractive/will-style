#= require outdatedbrowser

$(document).on 'turbolinks:load', (event) ->
    outdatedBrowser(
        bgColor: '#FF4967',
        color: '#ffffff',
        lowerThan: 'IE11',
        languagePath: ''
    )

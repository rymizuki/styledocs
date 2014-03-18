'use strict'

$ ->
  $('.lang-html').each () ->
    $this = $(this)
    $iframe = $('<iframe></iframe>')

    $this.parent().before $iframe

    $fdoc = $iframe.contents()
    $fdoc.find('body').html $this.text()
    $fdoc.find('head').append '<link rel="stylesheet" href="css/main.css">'

  prettyPrint()

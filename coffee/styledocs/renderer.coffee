'use strict'

_      = require 'underscore'
marked = require 'marked'
jade   = require 'jade'

marked.setOptions
  gfm: true

class Renderer
  filters:
    markdown: marked
    convert: marked
  jade: jade

  render: (template, args) ->
    opts = {}
    _.extend opts, @filters, args
    @jade.render template, opts

module.exports = Renderer

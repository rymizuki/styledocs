'use strict'

nopt = require 'nopt'
util =
  slice: Array.prototype.slice
  extend: (object) ->
    util.slice.call(arguments, 1).forEach (source) ->
      return if !source
      for prop of source
        object[prop] = source[prop]
    object

oplist =
  help:
    short: 'h'
    info: 'Display this help text.'
    type: Boolean
  verbose:
    short: 'v'
    info: 'Verbose mode. A lot more information output.'
    type: Boolean
  version:
    short: 'V'
    info: 'Print the styledocs version. Combine with --verbose for more info.'
    type: Boolean


# Parse `oplist` into a form that nopt can handle.
aliases = {}
known   = {}

Object.keys(oplist).forEach (key) ->
  # alias
  short = oplist[key].short
  aliases[short] = "--#{key}" if short
  # known
  known[key] = oplist[key].type

parsed = nopt known, aliases, process.argv, 2

default_options = parsed
delete parsed.argv

Object.keys(oplist).forEach (key) ->
  default_options[key] = [] if oplist[key].type == Array && !(key in default_options)

module.default_options = parsed
module.exports = (options, done) ->
  this.options = util.extend default_options, (options || {})

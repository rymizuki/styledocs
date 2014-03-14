'use strict'

fs   = require 'fs'
path = require 'path'
_    = require 'underscore'

Renderer  = require './styledocs/renderer'
CSSParser = require './styledocs/css_parser'

file_ext_regexp = /\.(css|scss|sass|less)$/
file_encoding   = 'utf8'
line_break_char = '\n'

class Styledocs
  # properties
  options: {}

  # methods
  cli:  require './styledocs/cli'
  file: require './styledocs/file'
#  parser:   new CSSParser()
  renderer: new Renderer()

  constructor: (options) ->
    if options?
      # TODO: extend
      this.options.input  = options.input  if options.input?
      this.oputons.output = options.output if options.output?

  execute: () ->
    if @options.help
      # TODO:
      return

    if @options.version
      # TODO:
      return

    input_dir  = @options.input
    output_dir = @options.output

    # initialize
    @file.mkpath output_dir unless @file.exists output_dir

    that = this
    # create navigation
    # execution
    @file.recurse input_dir, (full_path, rootdir, subdir, filename) ->
      if filename.match(file_ext_regexp)
        # stylesheet -> markdown
        sections = that.getSections full_path

        # markdown -> jade -> html
        html = that.compile sections

        # writing
        that.output subdir || '', filename, html

  getSections: (fpath) ->
    raw = fs.readFileSync fpath, file_encoding
    parser = new CSSParser(raw).parse()
    sections = parser.getSection 'docs'

  compile: (sections) ->
    # TODO:
    template_file = "#{ __dirname }/../share/template/docs.jade"
    template = fs.readFileSync template_file, file_encoding

    @renderer.render template,
      language: 'ja'
      sections: sections
      title: 'styledocs'
      pretty: true

  output: (subdir, input_file, html) ->
    output_dir  = path.join @options.output, subdir
    output_file = input_file.replace file_ext_regexp, '.html'

    @file.mkpath output_dir unless @file.exists output_dir

    fs.writeFileSync path.join(output_dir, output_file), html
    console.log 'write: %s', path.join(output_dir, output_file)

module.exports = Styledocs

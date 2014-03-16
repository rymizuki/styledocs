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
    @createNavigation input_dir

    # execution
    @file.recurse input_dir, (full_path, rootdir, subdir, filename) ->
      if filename.match(file_ext_regexp)
        # stylesheet -> markdown
        data = that.getSections full_path

        # markdown -> jade -> html
        html = that.compile data

        # writing
        that.output subdir || '', filename, html

  createNavigation: (rootdir) ->
    tmplLi = _.template '<li><a href="<%= href %>"><%= label %></a></li>'
    tmplUl = _.template '<li>'+
      '<a class="dropdown-toggle" href="<%= href %>" data-toggle="dropdown">'+
      '<%= label %> <b class="caret"></b>'+
      '</a><ul class="dropdown-menu"><%= list %></ul></li>'
    extHtml = (filename) -> filename.replace(/\.(css|sass|scss|less)$/, '.html')
    recureMake = (rootdir, subdir) ->
      abspath = path.join rootdir, (subdir || '')

      li = []
      fs.readdirSync(abspath).forEach (filename) ->
        filepath = path.join abspath, filename

        line = null
        if fs.statSync(filepath).isDirectory()
          line = tmplUl
            label: filename
            href:  '#'
            list:  recureMake abspath, filename
        else
          line = tmplLi
            label: filename
            href: path.join((subdir || ''), extHtml(filename)).split('/').join('-')
        li.push line
      li.join('')

    @navigation = "<ul class='nav navbar-nav'>#{recureMake rootdir}</ul>"

  getSections: (fpath) ->
    raw = fs.readFileSync fpath, file_encoding
    parser = new CSSParser(raw).parse()

    result  = []
    section = parser.getSection 'docs'
    parser.getSection('code').forEach (code) ->
      sass_content = code.join('\n')
      section = section.replace '<!-- CODE_SCOPE -->', '\n```scss\n' + sass_content + '\n```\n'


    data =
      sections: section
      codes:    parser.getSection 'code'
    data

  compile: (data) ->
    # TODO:
    template_file = "#{ __dirname }/../share/template/docs.jade"
    template = fs.readFileSync template_file, file_encoding

    @renderer.render template,
      data:
        language: 'ja'
        title: 'styledocs'
        style:  fs.readFileSync  "#{__dirname}/../share/css/docs.min.css",  file_encoding
        script: fs.readFileSync "#{__dirname}/../share/script/docs.min.js", file_encoding
        navigation: @navigation
        sections: data.sections
        codes:    _(data.codes)
          .filter (row) -> if row.length > 1 && row[0].length > 0 then true else false
          .map    (row) -> if _.isArray(row) then row.join('\n') else row
      pretty: true

  output: (subdir, input_file, html) ->
    output_file = input_file.replace file_ext_regexp, '.html'
    filename  = path.join(subdir, output_file).split('/').join('-')

    fs.writeFileSync path.join(@options.output, filename), html
    console.log 'write: %s', filename

module.exports = Styledocs

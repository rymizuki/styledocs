'use strict'

fs   = require 'fs'
path = require 'path'

Renderer  = require './styledocs/renderer'
CSSParser = require './styledocs/css_parser'

class Styledocs
  cli:  require './styledocs/cli'
  file: require './styledocs/file'
  parser:   new CSSParser()
  renderer: new Renderer()

  execute: () ->
    parser   = this.parser
    renderer = this.renderer
    f        = this.file

    dir  = '' # なんか入れて
    file = '' # なんか入れて
    dest_dir  = "dest/"
    encoding = 'utf8'

    do ->
      unless fs.existsSync(dest_dir)
        f.mkpath dest_dir

    do ->
      f.recurse dir, (fpath, rootdir, subdir, filename) ->
        if filename.match(/\.(css|scss|sass|less)$/)
          dest_f = filename.replace(/\.(css|scss|sass|less)/, '.html')
          dest_d = path.join dest_dir, subdir || ''

          unless fs.existsSync(dest_d)
            f.mkpath dest_d

          fs.readFile fpath, encoding, (err, raw) ->
            sections = parser.getSections(raw.split '\n')

            html = renderer.render [
              "doctype html"
              "html(lang='ja')"
              "  head"
              "    meta(charset='UTF-8')"
              "  body"
              "    != markdown(sections)"
            ].join('\n'), sections: sections

            fs.writeFileSync path.join(dest_d, dest_f), html
            console.log 'write: %s', path.join(dest_d, dest_f)

    console.log 'executed'

module.exports = Styledocs

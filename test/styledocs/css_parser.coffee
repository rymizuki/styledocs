'use strict'

expect = require 'expect.js'
fs     = require 'fs'

CSSParser = require '../../coffee/styledocs/css_parser.coffee'

css_raw = fs.readFileSync './test/share/test.scss', 'utf8'

describe 'css_parser', ->
  describe 'construction', ->

  describe '.isLineComment()', ->
    beforeEach ->
      @parser = new CSSParser()

    it '// comment', ->
      expect(@parser.isLineComment('// comment')).to.be.ok()
    it '/* comment */', ->
      expect(@parser.isLineComment('/* comment */')).to.be.ok()
    it 'body {', ->

      expect(@parser.isLineComment('body {')).to.not.be.ok()
    it '/* start', ->
      expect(@parser.isLineComment('/* start')).to.not.be.ok()
    it 'end */', ->
      expect(@parser.isLineComment('end */')).to.not.be.ok()

  describe '.isBlockCommentStart()', ->
    beforeEach ->
      @parser = new CSSParser()

    it '/* comment */', ->
      expect(@parser.isBlockCommentStart('/* comment */')).to.be.ok()
    it '/* start', ->
      expect(@parser.isBlockCommentStart('/* start')).to.be.ok()

    it '// comment', ->
      expect(@parser.isBlockCommentStart('// comment')).to.not.be.ok()
    it 'body {', ->
      expect(@parser.isBlockCommentStart('body {')).to.not.be.ok()
    it 'end */', ->
      expect(@parser.isBlockCommentStart('end */')).to.not.be.ok()

  describe '.isBlockCommentEnd()', ->
    beforeEach ->
      @parser = new CSSParser()

    it '/* comment */', ->
      expect(@parser.isBlockCommentEnd('/* comment */')).to.be.ok()
    it 'end */', ->
      expect(@parser.isBlockCommentEnd('end */')).to.be.ok()

    it '// comment', ->
      expect(@parser.isBlockCommentEnd('// comment')).to.not.be.ok()
    it 'body {', ->
      expect(@parser.isBlockCommentEnd('body {')).to.not.be.ok()
    it '/* start', ->
      expect(@parser.isBlockCommentEnd('/* start')).to.not.be.ok()

  describe '.isPreviewStart(line)', ->
    beforeEach ->
      @parser = new CSSParser()
      @parser.init()

    describe 'when call outside comment block', ->
      before ->
        @parser.in_block_fg = false

      it '"```" is false', ->
        expect(@parser.isPreviewStart '```').to.not.be.ok()

    describe 'when call inside comment block', ->
      beforeEach ->
        @parser.in_block_fg = true

      it '"```html" is true', ->
        expect(@parser.isPreviewStart '```html').to.be.ok()

    describe 'when call inside preview block', ->
      beforeEach ->
        @parser.in_block_fg   = true
        @parser.in_preview_fg = true

      it '"```html" is false', ->
        expect(@parser.isPreviewStart '```html').to.not.be.ok()

  describe '.isPreviewEnd(line)', ->
    beforeEach ->
      @parser = new CSSParser()
      @parser.init()

    describe 'when call outside comment block', ->
      before ->
        @parser.in_block_fg = false

      it '"```" is false', ->
        expect(@parser.isPreviewEnd '```').to.not.be.ok()

    describe 'when call inside comment block', ->
      beforeEach ->
        @parser.in_block_fg = true

      it '"```" is false', ->
        expect(@parser.isPreviewEnd '```').to.not.be.ok()

    describe 'when call inside preview block', ->
      beforeEach ->
        @parser.in_block_fg   = true
        @parser.in_preview_fg = true

      it '"```" is true', ->
        expect(@parser.isPreviewEnd '```').to.be.ok()

  describe '.removeCommentSyntax()', ->
    beforeEach ->
      @parser = new CSSParser()

    it '/* comment */', ->
      expect(@parser.removeCommentSyntax('/* comment */')).to.be.eql(' comment ')
    it 'end */', ->
      expect(@parser.removeCommentSyntax('end */')).to.be.eql('end ')

    it '// comment', ->
      expect(@parser.removeCommentSyntax('// comment')).to.be.eql(' comment')
    it 'body {', ->
      expect(@parser.removeCommentSyntax('body {')).to.be.eql('body {')
    it '/* start', ->
      expect(@parser.removeCommentSyntax('/* start')).to.be.eql(' start')

  describe '.init()', ->
    before ->
      @parser = new CSSParser()
      @parser.init()
      @parser.in_block_fg = true
      @parser.in_preview_fg = true
      @parser.section.code.push 'a', 'b', 'c'

    beforeEach ->
      @parser.init()

    it 'parser.in_block_fg is false', ->
      expect(@parser.in_block_fg).to.be.eql false

    it 'parser.in_preview_fg is false', ->
      expect(@parser.in_preview_fg).to.be.eql false

    it 'parser.section are null arrays', ->
      expect(@parser.section).to.be.eql
        code:    []
        docs:    []
        preview: []

  describe '.parse()', ->
  describe '.parseLine(line)', ->

  describe '.getLineType(line)', ->
    before ->
      @parser = new CSSParser()
      @parser.init()

    it '".class { color: red }" is "code"', ->
      expect(@parser.getLineType ".class { color: red}").to.be.eql 'code'
    it '"// comment" is "docs"', ->
      expect(@parser.getLineType "// comment").to.be.eql 'docs'
    it '"/* comment" is null', ->
      expect(@parser.getLineType "/* comment").to.be.eql null
    it '"comment" is "docs"', ->
      expect(@parser.getLineType "comment").to.be.eql 'docs'
    it '"```" is "docs"', ->
      expect(@parser.getLineType "```").to.be.eql 'docs'
    it '".class { color: red; }" is "docs"', ->
      expect(@parser.getLineType ".class { color: red; }").to.be.eql 'docs'
    it '"```" is "docs"', ->
      expect(@parser.getLineType "```").to.be.eql 'docs'
    it '"```html" is "docs"', ->
      expect(@parser.getLineType "```html").to.be.eql 'docs'
    it '".class { color: red; }" is "preview"', ->
      expect(@parser.getLineType ".class { color: red; }").to.be.eql 'preview'
    it '"```" is "docs"', ->
      expect(@parser.getLineType "```").to.be.eql 'docs'
    it '"```scss" is "docs"', ->
      expect(@parser.getLineType "```scss").to.be.eql 'docs'
    it '".class { color: red; }" is "docs"', ->
      expect(@parser.getLineType ".class { color: red; }").to.be.eql 'docs'
    it '"```" is "docs"', ->
      expect(@parser.getLineType "```").to.be.eql 'docs'
    it '"*/" is null', ->
      expect(@parser.getLineType "*/").to.be.eql null
    it '".class { color: red }" is "code"', ->
      expect(@parser.getLineType ".class { color: red}").to.be.eql 'code'

  describe '.addCollection(type, line)', ->
    before ->
      @parser = new CSSParser()

    describe 'type is "code"', ->
      before ->
        @parser.init()
        @parser.addCollection 'code', "this is line"

      it 'pushed parser.section.code', ->
        expect(@parser.section.code).to.be.eql [
          ['this is line']
        ]

    describe 'type is "docs"', ->
      before ->
        @parser.init()
        @parser.addCollection 'docs', "this is line"

      it 'pushed parser.section.docs', ->
        expect(@parser.section.docs).to.be.eql ['this is line']

    describe 'type is "preview"', ->
      before ->
        @parser.init()
        @parser.addCollection 'preview', "this is line"

      it 'pushed parser.section.preview', ->
        expect(@parser.section.preview).to.be.eql [
          ['this is line']
        ]

    describe 'when given a "null"', ->
      before ->
        @parser.init()
        @parser.addCollection 'code', null

      it 'can add', ->
        expect(@parser.section.code).to.be.eql [
          [null]
        ]

    describe 'when given a line including "//"', ->
      before ->
        @parser.init()
        @parser.addCollection 'code', "// comment"

      it 'removed "//"', ->
        expect(@parser.section.code).to.be.eql [
          [" comment"]
        ]

    describe 'when given a line including "/*"', ->
      before ->
        @parser.init()
        @parser.addCollection 'code', "/* comment"

      it 'removed "/*"', ->
        expect(@parser.section.code).to.be.eql [
          [" comment"]
        ]

    describe 'when given a line including "*/"', ->
      before ->
        @parser.init()
        @parser.addCollection 'code', "comment */"

      it 'removed "*/"', ->
        expect(@parser.section.code).to.be.eql [
          ["comment "]
        ]

  describe '.getSection(type)', ->
    before ->
      @parser = new CSSParser css_raw
      @parser.parse()

    describe 'type is docs', ->
      it 'got docs typeof string', ->
        expect(@parser.getSection 'docs').to.be.a 'string'
      it 'got docs part successful.', ->
        expect(@parser.getSection 'docs').to.be.eql [
          "# SCSS"
          "## body"
          ""
          "this is body's style."
          ""
          "```html"
          "<body>"
          "  <h1>Hello!</h1>"
          "  <p>It's awesome!!</p>"
          "</body>"
          "```"
          "## nav "
          ""
          "this is nav's style."
          ""
          "```html"
          "<nav>"
          "  <ul>"
          "    <li>item</li>"
          "    <li>item</li>"
          "    <li>item</li>"
          "  </ul>"
          "</nav>"
          "```"
        ].join '\n'

    describe 'type is preview', ->
      it 'got preview typeof array', ->
        expect(@parser.getSection 'preview').to.be.a 'array'
      it 'got preview part', ->
        expect(@parser.getSection 'preview').to.be.eql [
          [
            "<body>"
            "  <h1>Hello!</h1>"
            "  <p>It's awesome!!</p>"
            "</body>"
          ]
          [
            "<nav>"
            "  <ul>"
            "    <li>item</li>"
            "    <li>item</li>"
            "    <li>item</li>"
            "  </ul>"
            "</nav>"
          ]
        ]

    describe 'type is code', ->
      it 'got code typeof array', ->
        expect(@parser.getSection 'code').to.be.a 'array'
      it 'got code part', ->
        expect(@parser.getSection 'code').to.be.eql [
          [
            ""
          ]
          [
            ""
            "body {"
            "  font: 100% Helvetica, sans-serif;"
            "  color: #333;"
            "}"
            ""
          ]
          [
            ""
            "nav {"
            "  ul {"
            "    margin: 0;"
            "    padding: 0;"
            "    list-style: none;"
            "  }"
            ""
            "  li { display: inline-block; }"
            ""
            "  a {"
            "    display: block;"
            "    padding: 6px 12px;"
            "    text-decoration: none;"
            "  }"
            "}"
            ""
          ]
        ]

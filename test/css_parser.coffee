'use strict'

expect = require 'expect.js'

CSSParser = require '../coffee/styledocs/css_parser.coffee'

describe 'css_parser', ->
  describe '.isLineComment()', ->
    beforeEach ->
      this.parser = new CSSParser()

    it '// comment', ->
      expect(this.parser.isLineComment('// comment')).to.be.ok()
    it '/* comment */', ->
      expect(this.parser.isLineComment('/* comment */')).to.be.ok()
    it 'body {', ->

      expect(this.parser.isLineComment('body {')).to.not.be.ok()
    it '/* start', ->
      expect(this.parser.isLineComment('/* start')).to.not.be.ok()
    it 'end */', ->
      expect(this.parser.isLineComment('end */')).to.not.be.ok()

  describe '.isBlockCommentStart()', ->
    beforeEach ->
      this.parser = new CSSParser()

    it '/* comment */', ->
      expect(this.parser.isBlockCommentStart('/* comment */')).to.be.ok()
    it '/* start', ->
      expect(this.parser.isBlockCommentStart('/* start')).to.be.ok()

    it '// comment', ->
      expect(this.parser.isBlockCommentStart('// comment')).to.not.be.ok()
    it 'body {', ->
      expect(this.parser.isBlockCommentStart('body {')).to.not.be.ok()
    it 'end */', ->
      expect(this.parser.isBlockCommentStart('end */')).to.not.be.ok()

  describe '.isBlockCommentEnd()', ->
    beforeEach ->
      this.parser = new CSSParser()

    it '/* comment */', ->
      expect(this.parser.isBlockCommentEnd('/* comment */')).to.be.ok()
    it 'end */', ->
      expect(this.parser.isBlockCommentEnd('end */')).to.be.ok()

    it '// comment', ->
      expect(this.parser.isBlockCommentEnd('// comment')).to.not.be.ok()
    it 'body {', ->
      expect(this.parser.isBlockCommentEnd('body {')).to.not.be.ok()
    it '/* start', ->
      expect(this.parser.isBlockCommentEnd('/* start')).to.not.be.ok()

  describe '.removeCommentSyntax()', ->
    beforeEach ->
      this.parser = new CSSParser()

    it '/* comment */', ->
      expect(this.parser.removeCommentSyntax('/* comment */')).to.be.eql(' comment ')
    it 'end */', ->
      expect(this.parser.removeCommentSyntax('end */')).to.be.eql('end ')

    it '// comment', ->
      expect(this.parser.removeCommentSyntax('// comment')).to.be.eql(' comment')
    it 'body {', ->
      expect(this.parser.removeCommentSyntax('body {')).to.be.eql('body {')
    it '/* start', ->
      expect(this.parser.removeCommentSyntax('/* start')).to.be.eql(' start')

  describe '.getSections()', ->
    beforeEach ->
      this.parser = new CSSParser()

    it '', ->
      expect(this.parser.getSections([
        '/*'
        '# test'
        ' */'
        '// reset'
        'body {'
        '  heigth: 100%;'
        '}'
        '// content'
      ])).to.be.eql [
        ''
        '# test'
        ' '
        ' reset'
        ' content'
      ].join('\n')

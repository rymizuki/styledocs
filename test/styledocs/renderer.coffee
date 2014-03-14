'use strict'

expect   = require 'expect.js'
Renderer = require '../../coffee/styledocs/renderer'

describe 'Renderer', ->
  describe '.render()', ->
    beforeEach ->
      this.renderer = new Renderer

    it 'a plain syntax of jade', ->
      expect(this.renderer.render('h1 jade')).to.be.eql('<h1>jade</h1>')
    it 'a markdown syntax with jade', ->
      expect(this.renderer.render(':markdown\n  **jade**')).to.be.eql('<p><strong>jade</strong></p>\n')
    it 'markdown variable syntax with jade', ->
      expect(this.renderer.render('!= markdown(word)', word: '**jade**')).to.be.eql('<p><strong>jade</strong></p>\n')

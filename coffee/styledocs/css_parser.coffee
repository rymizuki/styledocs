'use strict'

# CSSの文字列から
#   commentを抽出
class CSSParser
  commentRegExp:
    line: /^\/\//
    block:
      start: /\/\*/
      end:  /\*\//
    preview:
      start: /```html/
      end:   /```$/

  constructor: (css_raw) ->
    @stylesheet = if css_raw? then css_raw else null

  _initStyleText: (stylesheet) ->
    target = stylesheet
    target.replace /(\r\n|\r|)/, '\n'
    target

  isLineComment: (line) ->
    return true if line.match(@commentRegExp.line)
    return true if line.match(@commentRegExp.block.start) && line.match(@commentRegExp.block.end)
    return false

  isBlockCommentStart: (line) ->
    return if line.match(@commentRegExp.block.start) then true else false

  isBlockCommentEnd: (line) ->
    return if line.match(@commentRegExp.block.end) then true else false

  isPreviewStart: (line) ->
    return if @in_block_fg && line.match(@commentRegExp.preview.start) && @in_preview_fg == false then true else false

  isPreviewEnd: (line) ->
    return if @in_block_fg && line.match(@commentRegExp.preview.end) && @in_preview_fg == true  then true else false

  removeCommentSyntax: (line) ->
    res = line
      .replace(this.commentRegExp.line,        '')
      .replace(this.commentRegExp.block.start, '')
      .replace(this.commentRegExp.block.end,   '')
    res

  init: () ->
    @in_block_fg   = false
    @in_preview_fg = false
    @cnt_preview = 0
    @cnt_code    = 0
    @cnt_docs    = 0
    @section =
      code:    []
      docs:    []
      preview: []

  parse: () ->
    @init()

    lines = @stylesheet.split '\n'

    that = this
    lines.forEach (line) ->
      that.parseLine(line)
    this

  parseLine: (line) ->
    type = @getLineType line

    if type == 'code'
      @addCollection 'code', line
    else if type == 'docs'
      @addCollection 'docs', line
    else if type == 'preview'
      @addCollection 'docs',    line
      @addCollection 'preview', line

  getLineType: (line) ->
    if !@in_block_fg && @isLineComment(line)
      return 'docs'
    else if @isPreviewEnd(line)
      @in_preview_fg = false
      @cnt_preview++
      return 'docs'
    else if @in_block_fg && @in_preview_fg
      return 'preview'
    else if @isPreviewStart(line)
      @in_preview_fg = true
      @section.preview[@cnt_preview] = []
      return 'docs'
    else if @in_block_fg && @isBlockCommentEnd(line)
      @in_block_fg = false
      @cnt_docs++
      @cnt_code = @cnt_docs - 1
      return null
    else if @in_block_fg
      return 'docs'
    else if @isBlockCommentStart(line)
      @in_block_fg = true
      return null
    else
      return 'code'

  addCollection: (type, line) ->
    raw = if line == null then line else @removeCommentSyntax(line)
    #console.log @section.code if type == 'code'

    if type == 'docs'
      @section.docs.push raw
    else
      num = this["cnt_#{ type }"]
      @section[type][num] = [] unless @section[type][num]
      @section[type][num].push raw

  getSection: (type) ->
    if type == 'docs'
      @section[type].join('\n')
    else
      @section[type]

module.exports = CSSParser

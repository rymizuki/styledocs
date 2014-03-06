'use strict'

# CSSの文字列から
#   commentを抽出
class CSSParser
  commentRegExp:
    line: /^\/\//
    block:
      start: /\/\*/
      end:  /\*\//

  _initStyleText: (stylesheet) ->
    target = stylesheet
    target.replace /(\r\n|\r|)/, '\n'
    target

  isLineComment: (line) ->
    return true if line.match(this.commentRegExp.line)
    return true if line.match(this.commentRegExp.block.start) && line.match(this.commentRegExp.block.end)
    return false

  isBlockCommentStart: (line) ->
    return if line.match(this.commentRegExp.block.start) then true else false

  isBlockCommentEnd: (line) ->
    return if line.match(this.commentRegExp.block.end) then true else false

  removeCommentSyntax: (line) ->
    res = line
      .replace(this.commentRegExp.line,        '')
      .replace(this.commentRegExp.block.start, '')
      .replace(this.commentRegExp.block.end,   '')
    res

  # コメント部分の抽出
  getSections: (lines) ->
    that = this
    sections = []
    in_block_fg = false

    lines.forEach (line) ->
      target = null
      if !in_block_fg && that.isLineComment(line)
        target = line
      else if in_block_fg
        if that.isBlockCommentEnd(line)
          target = line
          in_block_fg = false
        else
          target = line
      else if that.isBlockCommentStart(line)
        target = line
        in_block_fg = true

      sections.push that.removeCommentSyntax target if target
    sections.join '\n'

module.exports = CSSParser

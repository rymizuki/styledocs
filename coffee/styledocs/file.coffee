'use strict'

fs   = require 'fs'
path = require 'path'

pathSeparatorRe = /[\/\\]]/g

module.exports =
  recurse: recurse = (rootdir, callback, subdir) ->
    abspath = if subdir then path.join(rootdir, subdir) else rootdir
    fs.readdirSync(abspath).forEach (filename) ->
      filepath = path.join abspath, filename
      if fs.statSync(filepath).isDirectory()
        recurse rootdir, callback, path.join(subdir || '', filename || '')
      else
        callback filepath, rootdir, subdir, filename
  mkdir: (dirpath, mode) ->
    mode = parseInt('0777', 8) & (~process.unmask()) if mode == null

    dirpath.split(pathSeparatorRe).reduce(
      (parts, part) ->
        parts += "#{part}/"
        subpath = path.resolve parts
        if !fs.existsSync(subpath)
          try
            fs.mkdirSync subpath, mode
          catch e
            throw new Error("Unable to create directory '#{subpath}' (Error code: #{ e.code })")
        console.log parts
        parts
      , '')
  mkpath: mkpath = (dirpath, mode) ->
    mode = parseInt('0777', 8) & (~process.unmask()) if mode == null

    dirpath = path.resolve dirpath

    try
      if !fs.statSync(dirpath).isDirectory()
        throw new Error(dirpath + ' exists and is not directory')
    catch e
      if e.code == 'ENOENT'
        mkpath path.dirname(dirpath), mode
        fs.mkdirSync dirpath, mode
      else
        throw e

    return

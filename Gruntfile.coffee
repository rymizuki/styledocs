'use strict'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'test', ['coffeelint', 'simplemocha']

  grunt.initConfig
    watch:
      gruntfile:
        files: ["Gruntfile.coffee"]
        tasks: ["coffeelint:gruntfile"]
      docs:
        files: [
          "coffee/*.coffee"
          "coffee/**/*.coffee"
        ]
        tasks: [
          "coffeelint:docs"
          "simplemocha"
        ]
      spec:
        files: [
          "test/*.coffee"
          "test/**/*.coffee"
        ]
        tasks: [
          "coffeelint:spec"
          "simplemocha"
        ]

    coffeelint:
      options:
        max_line_length:
          value: 120
      gruntfile: [
        'Gruntfile.coffee'
      ]
      docs: [
        'coffee/*.coffee'
        'coffee/**/*.coffee'
      ]
      spec: [
        'test/*.coffee'
        'test/**/*.coffee'
      ]

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'spec'
      docs:
        src: ["test/**/*.coffee"]

    concat:
      view:
        src: [
          "bower_components/jquery/dist/jquery.min.js"
          "bower_components/bootstrap/dist/js/bootstrap.min.js"
        ]
        dest: "share/script/docs.js"


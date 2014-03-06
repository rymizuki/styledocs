'use strict'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'

  grunt.registerTask 'test', ['coffeelint', 'simplemocha']

  grunt.initConfig
    watch:
      gruntfile:
        files: ["Gruntfile.coffee"]
        tasks: ["coffeelint:gruntfile"]
      main:
        files: [
          "coffee/*.coffee"
          "coffee/**/*.coffee"
        ]
        tasks: [
          "coffeelint:main"
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
      main: [
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
      main:
        src: ["test/**/*.coffee"]

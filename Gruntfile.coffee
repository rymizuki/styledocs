'use strict'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'test', ['coffeelint', 'simplemocha', 'coffee']
  grunt.registerTask 'view', ["concat", "uglify", "cssmin"]

  grunt.initConfig
    watch:
      gruntfile:
        files: ["Gruntfile.coffee"]
        tasks: ["coffeelint:gruntfile"]
      docs:
        files: [
          "coffee/styledocs.coffee"
          "coffee/styledocs/*.coffee"
          "coffee/styledocs/**/*.coffee"
        ]
        tasks: [
          "coffeelint:docs"
          "simplemocha"
        ]
      view:
        files: [
          "coffee/view/*.coffee"
          "coffee/view/**/*.coffee"
        ]
        tasks: ["coffee:view"]
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
        'coffee/styledocs.coffee'
        'coffee/styledocs/*.coffee'
        'coffee/styledocs/**/*.coffee'
      ]
      view: [
        "coffee/view/*.coffee"
        "coffee/view/**/*.coffee"
      ]
      spec: [
        'test/*.coffee'
        'test/**/*.coffee'
      ]

    coffee:
      view:
        files:
          "share/script/preview.js": [
            "coffee/view/*.coffee"
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
          "bower_components/google-code-prettify/src/prettify.js"
        ]
        dest: "share/script/docs.js"

    uglify:
      view:
        files:
          "share/script/docs.min.js": "<%= concat.view.dest %>"

    cssmin:
      view:
        files:
          "share/css/docs.min.css": [
            "bower_components/bootstrap/dist/css/bootstrap.css"
            "bower_components/google-code-prettify/src/prettify.css"
          ]

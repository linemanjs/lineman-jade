module.exports = (lineman) ->
  files:
    pug:
      templates: "app/templates/**/*.pug"
      generatedTemplate: "generated/template/pug.js"
      pages: "**/*.pug"
      pageRoot: "app/pages/"
    template:
      pug: "app/templates/**/*.pug"
      generatedPug: "generated/template/pug.js"
    pages:
      source: lineman.config.files.pages.source.concat("!<%= files.pug.pageRoot %>/<%= files.pug.pages %>")

  config:
    loadNpmTasks: lineman.config.application.loadNpmTasks.concat('grunt-contrib-pug')

    prependTasks:
      common: ["pug:templates"].concat(lineman.config.application.prependTasks.common)
      dev: lineman.config.application.prependTasks.common.concat("pug:pagesDev")
      dist: lineman.config.application.prependTasks.common.concat("pug:pagesDist")

    pug:
      templates:
        options:
          client: true
        files:
          "<%= files.pug.generatedTemplate %>": "<%= files.pug.templates %>"
      pagesDev:
        options:
          pretty: true
          data:
            js: "js/app.js"
            css: "css/app.css"
            pkg: "<%= pkg %>"
        files: [{
          expand: true
          src: "<%= files.pug.pages %>"
          cwd: "<%= files.pug.pageRoot %>"
          dest: "generated/"
          ext: ".html"
        }]
      pagesDist:
        options:
          data:
            js: "js/app.js"
            css: "css/app.css"
            pkg: "<%= pkg %>"
        files: [{
          expand: true
          src: "<%= files.pug.pages %>"
          cwd: "<%= files.pug.pageRoot %>"
          dest: "dist/"
          ext: ".html"
        }]

    watch:
      pugPages:
        files: ["<%= files.pug.pageRoot %><%= files.pug.pages %>", "<%= files.pug.templates %>"]
        tasks: ["pug:pagesDev"]
      pugTemplates:
        files: "<%= files.pug.templates %>"
        tasks: ["pug:templates", "concat_sourcemap:js"]

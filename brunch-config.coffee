exports.config =
  # https://github.com/brunch/brunch/blob/stable/docs/config.md

#  paths -> watched

  files:
    # Overall ordering is [before] -> [bower] -> [vendor] -> [everything else] -> [after]
    javascripts:
      joinTo:

        'js/vendor.js': /^(bower_components|vendor)/

#        'js/vendor.js': (path) ->
#          path.match /^(bower_components|vendor)/

#          if path.match(/bower_components\/bootstrap-sass-official\/vendor\/assets\/javascripts\/bootstrap.js/)
#            return true
#          if path.match(/bower_components\/bootstrap-sass-official\/vendor\/assets\/javascripts\/bootstrap\/(\w+).js$/)
#            return false
#          else
#            return true if path.match(/^(bower_components|vendor)/)
#            return false

#          if path.indexOf('bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/') != -1
#            return false
#          else
#            return true if path.match(/^(bower_components|vendor)/)
#            return false

#          console.log path if path.match(/.js$/) and path.match(/bootstrap-sass-official/)
#          console.log path if path.match(/bootstrap-sass-official/)
#
#          return true if path.match(/^(bower_components|vendor)/)
#          return false




        'js/bootstrap-password.js': /^app/

      order:
        before: [
          'bower_components/jquery/dist/jquery.js'
          'bower_components/jquery-ui/ui/jquery-ui.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/affix.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/alert.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/button.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/carousel.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/collapse.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/dropdown.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tab.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/transition.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/scrollspy.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/modal.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tooltip.js'
          'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/popover.js'
        ]

    stylesheets:
      joinTo:
        'css/vendor.css': /^(bower_components|vendor)/
        'css/bootstrap-password.css': /^app/
      order:
        before: [
          'bower_components/bootstrap-sass-official/vendor/assets/stylesheets/bootstrap.scss'
        ]

#	    templates:
#            joinTo: 'js/app.js'

  plugins:
    autoReload:
      enabled:
        js: on
        css: on
        assets: off

    imageoptimizer:
      path: 'images'
      smushit: no

    coffeelint:
      pattern: /^app\/.*\.coffee$/

      options:
      #                indentation:
      #                    value: 4
      #                    level: "warn"
      #
        max_line_length:
          level: "ignore"
        no_unnecessary_fat_arrows:
          level: "ignore"

#    sass:
#      mode: 'ruby'
#      gem_home: '~/.rvm/gems/ruby-1.9.3-p448@af-calendar'

  conventions:
    # defaults here: https://github.com/brunch/brunch/blob/stable/src/helpers.coffee#L227
    assets: /^app[\/\\]+assets[\/\\]+/ # works
#    assets: /(^app[\/\\]+assets[\/\\]+|bower_components\/x-editable\/dist\/bootstrap3-editable\/img)/

#    assets: /(app\/assets|font)/
#    assets: /app\/(assets|vendor\/assets|font)/
#    assets: /app(\\|\/)assets(\\|\/)/
#    assets: /(assets|vendor\/assets|font)/
#    assets: /^(app[\/\\]+assets[\/\\]+|bower_components\/bootstrap-sass-official\/vendor\/assets\/fonts\/bootstrap)/
#    assets: /^(app[\/\\]+assets[\/\\]+|bower_components\/bootstrap-sass-official\/vendor\/assets\/javascripts\/bootstrap\/(\w+).js)/
#    ignored: -> false
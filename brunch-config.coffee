exports.config =
  # https://github.com/brunch/brunch/blob/stable/docs/config.md

#  paths -> watched

  files:
    # Overall ordering is [before] -> [bower] -> [vendor] -> [everything else] -> [after]
    javascripts:
      joinTo:

        'js/vendor.js': /^(bower_components|vendor)/
        'js/bootstrap-password.js': /^app/

      order:
        before: [
          'bower_components/jquery/dist/jquery.js'
#          'bower_components/jquery-ui/ui/jquery-ui.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/affix.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/alert.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/button.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/carousel.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/collapse.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/dropdown.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tab.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/transition.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/scrollspy.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/modal.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tooltip.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/popover.js'
        ]

    stylesheets:
      joinTo:
        'css/vendor.css': /^(bower_components|vendor)/
        'css/bootstrap-password.css': /^app/
      order:
        before: [
          'bower_components/bootstrap-sass-official/assets/stylesheets/bootstrap.scss'
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

  conventions:
    # defaults here: https://github.com/brunch/brunch/blob/stable/src/helpers.coffee#L227
    assets: /^app[\/\\]+assets[\/\\]+/ # works
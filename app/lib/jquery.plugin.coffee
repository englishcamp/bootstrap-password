# Reference jQuery
$ = jQuery
PasswordInput = require 'lib/password_input'


# Adds plugin object to jQuery
$.fn.extend

  _defaultOptions:

    lang: 'en'
    allowToggle: true
    backgroundMeter: false
    icons: false

    'input-group':
      layout: false # || array of addons and input indicating order ['strength', 'input', ]

    en:
      meter:
        veryWeak: 'Very Weak'
        weak: 'Weak'
        medium: 'Medium'
        strong: 'Strong'
        none: 'Strength'
      show: 'Show Password'
      hide: 'Hide Password'

    # calculation can be a function, or users can override the test regexes below
    calculation:
      weakTest: /^[a-zA-Z0-9]{6,}$/
      mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
      strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/

  bootstrapPassword: (options) ->

    # Merge default options with the provided options.
    @options = $.extend true, {}, @_defaultOptions, options

    # _Insert magic here._
    return @each ()=>
      # A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
      $.data(this, 'bootstrapPassword', new PasswordInput(this, @options))  unless $.data(this, 'bootstrapPassword')

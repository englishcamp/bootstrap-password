# Reference jQuery
$ = jQuery
PasswordInput = require 'lib/password_input'


# Adds plugin object to jQuery
$.fn.extend

  _defaultOptions:

    lang: 'en'
    allowShow: true


    strengthClass: 'strength'
    strengthMeterClass: 'strength_meter'

    en:
      meter:
        veryWeak: 'very weak'
        weak: 'weak'
        medium: 'medium'
        strong: 'strong'
        none: 'strength'
      show: 'Show Password'
      hide: 'Hide Password'

    wrapper: false
    wrapperClass: 'strength_wrapper'
    showHideButtonClass: 'button_showhide'

    # calculation can be a function, or users can override the test regexes below
    calculation:
      weakTest: /^[a-zA-Z0-9]{6,}$/
      mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
      strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/

  bootstrap_password: (options) ->

    # Merge default options with the provided options.
    @options = $.extend {}, @_defaultOptions, options

    # _Insert magic here._
    return @each ()=>
      # A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
      $.data(this, 'bootstrap_password', new PasswordInput(this, @options))  unless $.data(this, 'bootstrap_password')

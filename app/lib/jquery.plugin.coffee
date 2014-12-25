# Reference jQuery
$ = jQuery
PasswordInput = require 'lib/password_input'


# Adds plugin object to jQuery
$.fn.extend

  _defaultOptions:
    strengthClass: 'strength'
    strengthMeterClass: 'strength_meter'
    veryWeakText: 'very weak'
    weakTest: /^[a-zA-Z0-9]{6,}$/
    weakText: 'weak'
    mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
    mediumText: 'medium'
    strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
    strongText: 'strong'
    wrapper: false
    wrapperClass: 'strength_wrapper'
    showHide: true
    showHideButtonClass: 'button_showhide'
    showHideButtonText: 'Show Password'
    showHideButtonTextToggle: 'Hide Password'

  bootstrap_password: (options) ->

    # Merge default options with the provided options.
    @options = $.extend {}, @_defaultOptions, options

    # _Insert magic here._
    return @each ()=>
      # A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
      $.data(this, 'bootstrap_password', new PasswordInput(this, @options))  unless $.data(this, 'bootstrap_password')

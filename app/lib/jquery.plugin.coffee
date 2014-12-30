# Reference jQuery
$ = jQuery
PasswordInput = require 'lib/password_input'


# Adds plugin object to jQuery
$.fn.extend

  _defaultOptions:

    lang: 'en'

    features: ['background-meter', 'input-group'] # one of 'background-meter', 'input-group', 'toggle-visibility-link'

    'input-group':
      layout: ['password-strength', 'input', 'toggle-visibility'] # || array of addons and input indicating order ['password-strength', 'input', 'toggle-visibility']

      # define addons here, to be referenced by `layout` array above
      addons:
        'toggle-visibility':
          html: '<span class="toggle-visibility icon-toggle-visibility" aria-hidden="true"></span>'
        'password-strength':
          html: '<span class="icon-password-strength" aria-hidden="true"></span>'

    en:
      meter:
        veryWeak: 'Very Weak'
        weak: 'Weak'
        medium: 'Medium'
        strong: 'Strong'
        none: 'Strength'
      show: 'Show'
      hide: 'Hide'

    # calculation can be a function (#calculation(newValue, options)), or users can override the test regexes below
    calculation:
      weakTest: /^[a-zA-Z0-9]{6,}$/
      mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
      strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/

  bootstrapPassword: (options = {}) ->

    # Below we are going to deep merge. The following are nice to be defaulted, but deep merge is unexpected.
    #  - input-group layouts
    #  - features
    defaultOptions = $.extend true, {}, @_defaultOptions  # never overwrite static defaultOptions, make a copy first

    # If provided, kill default and overwrite.
    defaultOptions['input-group'].layout = null if options['input-group']?.layout?
    defaultOptions['features'] = null if options['features']?

    # Merge default options with the provided options.
    @options = $.extend true, {}, defaultOptions, options

    # _Insert magic here._
    return @each ()=>
      # A really lightweight plugin wrapper around the constructor, preventing against multiple instantiations
      $.data(this, 'bootstrapPassword', new PasswordInput(this, @options))  unless $.data(this, 'bootstrapPassword')

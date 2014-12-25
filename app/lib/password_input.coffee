class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @formGroup = @element.parents('.form-group')

    @id = @element.attr('id')
    @isShown = false
    @i18n = @options[@options.lang]

    # hookup detection
    @element.keyup(@onKeyup)

    # create wrapper if requested
    if @options.wrapper is true

      # does the input even need a wrapper? Does one already exist?
      parent = @element.parent()
      return  if (parent.css('position') is 'relative' or parent.css('position') is 'absolute') and parent.width() is @element.width() and parent.height() is @element.height()

      # else create one
      wrapperCSS =
        position: 'relative'
        display: @element.css('display')
        verticalAlign: @element.css('verticalAlign')
        width: @element.css('width')
        height: @element.css('height')
        marginTop: @element.css('marginTop')
        marginRight: @element.css('marginRight')
        marginBottom: @element.css('marginBottom')
        marginLeft: @element.css('marginLeft')
        fontSize: @element.css('fontSize')
        borderRadius: @element.css('borderRadius')

      @element.wrap $('<div />').addClass(@options.wrapperClass).css(wrapperCSS)

    # create strength meter outer div and inner label.  Looks like:
    #    <div class="meter">
    #      <div class="none">Strength</div>
    #    </div>
    @meterElement = $("<div class='#{@options.meterClass}'>")
    @meterLabelElement = $("<div>#{@i18n.meter.none}</div>")
    @meterLabelElement.appendTo @meterElement
    @element.after @meterElement

    # create 'show/hide' toggle and 'text' version of password field
    if @options.allowShow is true
      @showHideElement = $("<a href='#' class='#{@options.toggleVisibilityClass}'>#{@i18n.show}</a>")
      @element.after @showHideElement

      # events to trigger show/hide for password field
      @showHideElement.click(@onShowHideClick)


  onShowHideClick: (ev) =>
    ev.preventDefault()

    hideClass = "hide-#{@options.toggleVisibilityClass}"
    if @isShown
      @element.attr('type', 'password')
      if @options.allowShow is true
        @showHideElement.removeClass(hideClass).html @i18n.show
      @isShown = false
    else
      @element.attr('type', 'text')
      if @options.allowShow is true
        @showHideElement.addClass(hideClass).html @i18n.hide
      @isShown = true

  onKeyup: (ev) =>
    # events to trigger strength meter and update the hidden field
    strength = @calculateStrength(@element.val())
    @updateUI strength

  updateUI: (strength) =>
    @meterLabelElement.removeClass().addClass(strength)

    switch strength
      when 'strong', 'medium', 'weak', 'none'
        @meterLabelElement.text(@i18n.meter[strength])
      else
        @meterLabelElement.text @i18n.meter.veryWeak

  calculateStrength: (newValue) =>
    #
    # Check the password against the calculation. Allow someone to pass in a different `calculation` fn via options.
    #   Any given function should return strength string values of strength|veryweak|weak|strong
    #
    if typeof @options.calculation is 'function'
      calculation = @options.calculation
    else
      calculation = @defaultCalculation

    calculation(newValue)

  defaultCalculation: (newValue) =>
    # check the password against the regexes given in the options (defaulted as well)
    if newValue.length is 0
      'none'
    else if newValue.search(@options.calculation.strongTest) >= 0
      'strong'
    else if newValue.search(@options.calculation.mediumTest) >= 0
      'medium'
    else if newValue.search(@options.calculation.weakTest) >= 0
      'weak'
    else
      'veryWeak'

module.exports = PasswordInput
class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @id = @element.attr('id')
    @formGroupElement = @element.parents('.form-group')
    @formGroupElement.addClass('bootstrap-password')
    @formGroupElement.addClass('background-metered') if @options.backgroundMeter
    $.error("Form input ##{@id} must have a surrounding form-group.") unless @formGroupElement.length > 0

    @isShown = false
    @i18n = @options[@options.lang]

    # hookup detection
    @element.keyup(@onKeyup)

    if @options.icons is true
      @inputGroupElement = $('<div class="input-group"></div>')
      @element.wrap @inputGroupElement
      beforeIcon =
        $("""
          <div class="input-group-addon">
            <span class="icon-password-strength" aria-hidden="true"></span>
          </div>
          """)
      @element.before beforeIcon


      # create 'show/hide' toggle icon
      if @options.allowToggle is true
        afterIcon =
        # icon-x temporary for icomoon until we convert
          $("""
            <div class="input-group-addon">
              <span class="toggle-visibility icon-toggle-visibility" aria-hidden="true"></span>
            </div>
            """)

        @element.after afterIcon
        @toggleVisibilityIconElement = afterIcon.find(".toggle-visibility")
        # events to trigger show/hide for password field
        @toggleVisibilityIconElement.click(@onToggleVisibility)

    if @options.backgroundMeter is true

      @backgroundMeterElement = $("<div class='background-meter' />")
      @formGroupElement.append @backgroundMeterElement

      meterGroupElement = @backgroundMeterElement


    # create strength meter outer div and inner label.  Looks like:
    #    <div class="meter">
    #      <div class="none">Strength</div>
    #    </div>
    unless meterGroupElement
      meterGroupElement = $("<div class='meter-group'/>")
      @element.after meterGroupElement

    @meterElement = $("<div class='meter'>")
    @meterLabelElement = $("<div>#{@i18n.meter.none}</div>")
    @meterLabelElement.appendTo @meterElement
    meterGroupElement.append @meterElement

    # create 'show/hide' toggle and 'text' version of password field (not for the one with the background-meter)
    if @options.icons is false and @options.allowToggle is true
      @toggleVisibilityTextElement = $("<a href='#' class='toggle-visibility'>#{@i18n.show}</a>")
      @formGroupElement.append @toggleVisibilityTextElement

      # events to trigger show/hide for password field
      @toggleVisibilityTextElement.click(@onToggleVisibility)

    # trigger initial strength update and background-meter underlay placement
    @onKeyup()
    @onResize()

    $(window).resize @onResize


  onResize: =>
    # resetBackgroundMeterCss - now that position and everything is calculated, grab the css from the input and add it to our backgroundMeterElement

    return unless @backgroundMeterElement?

    backgroundMeterCss =
      position: 'absolute'
      verticalAlign: @element.css('verticalAlign')
      width: @element.css('width')
      height: @element.css('height')
      borderRadius: @element.css('borderRadius')
      'z-index': -1

    @backgroundMeterElement.css(backgroundMeterCss)
    @backgroundMeterElement.offset(@element.offset())

  onToggleVisibility: (ev) =>
    ev.preventDefault()

    if @isShown
      @element.attr('type', 'password')
      if @options.allowToggle is true
        @toggleVisibilityIconElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility') if @toggleVisibilityIconElement
        @toggleVisibilityTextElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility').html @i18n.show if @toggleVisibilityTextElement
      @isShown = false
    else
      @element.attr('type', 'text')
      if @options.allowToggle is true
        @toggleVisibilityIconElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility') if @toggleVisibilityIconElement
        @toggleVisibilityTextElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility').html @i18n.hide if @toggleVisibilityTextElement
      @isShown = true

  onKeyup: (ev) =>
    # events to trigger strength meter and update the hidden field
    strength = @calculateStrength(@element.val())
    @updateUI strength

  updateUI: (strength) =>
    for cssClass in ['strong', 'medium', 'weak', 'veryWeak', 'none']
      @formGroupElement.removeClass(cssClass)

    @formGroupElement.addClass(strength)

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
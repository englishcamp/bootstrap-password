class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @id = @element.attr('id')
    @formGroupElement = @element.parents('.form-group')
    $.error("Form input ##{@id} must have a surrounding form-group.") unless @formGroupElement.length > 0

    @isShown = false
    @i18n = @options[@options.lang]

    # hookup detection
    @element.keyup(@onKeyup)

    afterElement = @element

    # create wrapper if requested
    if @options.backgroundMeter is true

      @inputGroupElement = $('<div class="input-group" />')
      @element.wrap @inputGroupElement
      beforeIcon =
        $("""
          <div class="input-group-addon">
            <span class="glyphicon glyphicon-before-password" aria-hidden="true"></span>
          </div>
          """)
      @element.before beforeIcon


      # create 'show/hide' toggle icon
      if @options.allowShow is true
        afterIcon =
        # icon-x temporary for icomoon until we convert
          $("""
            <div class="input-group-addon">
              <a href='#' class='#{@options.toggleVisibilityClass}'>
                <span class="glyphicon glyphicon-after-password" aria-hidden="true"></span>
              </a>
            </div>
            """)

        @element.after afterIcon
        @toggleVisibilityIconElement = afterIcon.find(".#{@options.toggleVisibilityClass}")
        # events to trigger show/hide for password field
        @toggleVisibilityIconElement.click(@onToggleVisibility)


      backgroundMeterCss =
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

      @backgroundMeterElement = $('<div />').addClass(@options.backgroundMeterClass).css(backgroundMeterCss)
      @element.wrap @backgroundMeterElement

    # create strength meter outer div and inner label.  Looks like:
    #    <div class="meter">
    #      <div class="none">Strength</div>
    #    </div>
    @meterElement = $("<div class='#{@options.meterClass}'>")
    @meterLabelElement = $("<div>#{@i18n.meter.none}</div>")
    @meterLabelElement.appendTo @meterElement
    afterElement = afterElement.after @meterElement

    # create 'show/hide' toggle and 'text' version of password field (not for the one with the background-meter)
    if @options.backgroundMeter is false and @options.allowShow is true
      @toggleVisibilityTextElement = $("<a href='#' class='#{@options.toggleVisibilityClass}'>#{@i18n.show}</a>")
      afterElement.after @toggleVisibilityTextElement

      # events to trigger show/hide for password field
      @toggleVisibilityTextElement.click(@onToggleVisibility)


    # alter css dynamically as necessary to match the input's
    if @options.backgroundMeter is true
      meterLabelCss =
        borderRadius: @element.css('borderRadius')
      @meterLabelElement.css(meterLabelCss)

    # trigger initial strength update
    @onKeyup()



  onToggleVisibility: (ev) =>
    ev.preventDefault()

    hideClass = "hide-#{@options.toggleVisibilityClass}"
    if @isShown
      @element.attr('type', 'password')
      if @options.allowShow is true
        @toggleVisibilityIconElement.removeClass().addClass(@options.toggleVisibilityClass) if @toggleVisibilityIconElement
        @toggleVisibilityTextElement.removeClass().addClass(@options.toggleVisibilityClass).html @i18n.show if @toggleVisibilityTextElement
      @isShown = false
    else
      @element.attr('type', 'text')
      if @options.allowShow is true
        @toggleVisibilityIconElement.removeClass().addClass(hideClass) if @toggleVisibilityIconElement
        @toggleVisibilityTextElement.removeClass().addClass(hideClass).html @i18n.hide if @toggleVisibilityTextElement
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
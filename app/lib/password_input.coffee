class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @id = @element.attr('id')
    @isShown = false
    @i18n = @options[@options.lang]

    # prep password field
    @element.addClass(@options.strengthClass).attr 'data-password', @id
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

    # create strength meter
    @element.after """
      <div class='#{@options.strengthMeterClass}'>
        <div data-meter='#{@id}'>Strength</div>
      </div>
    """

    # create 'show/hide' toggle and 'text' version of password field
    if @options.allowShow is true
      @showHideElement = $("<a data-password-button='#{@id}' href='' class='#{@options.showHideButtonClass}'>#{@i18n.show}</a>")
      @element.after @showHideElement

      # events to trigger show/hide for password field
      @showHideElement.click(@onShowHideClick)


  onShowHideClick: (ev) =>
    ev.preventDefault()

    hideClass = "hide_#{@options.showHideButtonClass}"
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
    meterElement = $("div[data-meter='#{@id}']")
    meterElement.removeClass().addClass(strength)

    switch strength
      when 'strong', 'medium', 'weak', 'none'
        meterElement.text(@i18n.meter[strength])
      else
        meterElement.text @i18n.meter.veryWeak

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
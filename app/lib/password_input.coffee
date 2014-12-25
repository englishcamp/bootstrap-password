class PasswordInput

  constructor: (element, @options) ->
    @element = $(element)
    @id = @element.attr('id')
    @isShown = false

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
    if @options.showHide is true
      @hiddenInputElement = $("<input type='text' data-password='#{@id}' name='#{@element.attr('name')}' class='hidden #{@element.attr('class') + @options.strengthClass}' placeholder='#{@element.attr('placeholder')}' value='' disabled='disabled'>")
      @showHideElement = $("<a data-password-button='#{@id}' href='' class='#{@options.showHideButtonClass}'>#{@options.showHideButtonText}</a>")
      @element.after @hiddenInputElement
      @element.after @showHideElement

      # events to trigger show/hide for password field
      @showHideElement.click(@onShowHideClick)


  onShowHideClick: (ev) =>
    ev.preventDefault()

    hideClass = "hide_#{@options.showHideButtonClass}"
    if @isShown
      @element.prop('disabled', false).show().focus()
      if @options.showHide is true
        @hiddenInputElement.prop('disabled', true).hide()
        @showHideElement.removeClass(hideClass).html @options.showHideButtonText
      @isShown = false
    else
      @element.prop('disabled', true).hide()
      if @options.showHide is true
        @hiddenInputElement.prop('disabled', false).show().focus()
        @showHideElement.addClass(hideClass).html @options.showHideButtonTextToggle
      @isShown = true

  onKeyup: (ev) =>
    # events to trigger strength meter and update the hidden field
    newValue = @element.val()
    if @options.showHide is true
      @hiddenInputElement.val(newValue)
    @updateStrength newValue

  # check the password against the tests
  updateStrength: (newValue) =>
    meterElement = $("div[data-meter='#{@id}']")
    if newValue.length is 0
      meterElement.removeClass().text 'strength'
    else if newValue.search(@options.strongTest) >= 0
      meterElement.removeClass().addClass('strong').text @options.strongText
    else if newValue.search(@options.mediumTest) >= 0
      meterElement.removeClass().addClass('medium').text @options.mediumText
    else if newValue.search(@options.weakTest) >= 0
      meterElement.removeClass().addClass('weak').text @options.weakText
    else
      meterElement.removeClass().addClass('veryweak').text @options.veryWeakText

module.exports = PasswordInput
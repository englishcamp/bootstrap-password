(($, window, document, undefined_) ->
  # minimum acceptable: min 6 chars, any caps/no-caps/number, no spaces
  # reasonable: min 8 chars, either caps+no-caps or no-caps+numbers, no spaces
  # strong: min 8 chars, caps+no-caps+numbers, no spaces
  Plugin = (element, options) ->
    @element = element
    @$elem = $(@element)
    @options = $.extend({}, defaults, options)
    @_defaults = defaults
    @_name = pluginName
    @init()
    return
  pluginName = "strength"
  defaults =
    strengthClass: "strength"
    strengthMeterClass: "strength_meter"
    veryWeakText: "very weak"
    weakTest: /^[a-zA-Z0-9]{6,}$/
    weakText: "weak"
    mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
    mediumText: "medium"
    strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
    strongText: "strong"
    wrapper: false
    wrapperClass: "strength_wrapper"
    showHide: true
    showHideButtonClass: "button_showhide"
    showHideButtonText: "Show Password"
    showHideButtonTextToggle: "Hide Password"

  Plugin:: = init: ->

    # check the password against the tests
    check_strength = (thisval, thisid) ->
      thismeter = $("div[data-meter=\"" + thisid + "\"]")
      if thisval.length is 0
        thismeter.removeClass().text "strength"
      else if thisval.search(options.strongTest) >= 0
        thismeter.removeClass().addClass("strong").text options.strongText
      else if thisval.search(options.mediumTest) >= 0
        thismeter.removeClass().addClass("medium").text options.mediumText
      else if thisval.search(options.weakTest) >= 0
        thismeter.removeClass().addClass("weak").text options.weakText
      else
        thismeter.removeClass().addClass("veryweak").text options.veryWeakText
      return
    options = @options
    isShown = false
    thisid = @$elem.attr("id")

    # prep password field
    @$elem.addClass(@options.strengthClass).attr "data-password", thisid

    # create wrapper if requested
    if options.wrapper is true

      # does the input even need a wrapper? Does one already exist?
      parent = @$elem.parent()
      return  if (parent.css("position") is "relative" or parent.css("position") is "absolute") and parent.width() is @$elem.width() and parent.height() is @$elem.height()

      # else create one
      wrapperCSS =
        position: "relative"
        display: @$elem.css("display")
        verticalAlign: @$elem.css("verticalAlign")
        width: @$elem.css("width")
        height: @$elem.css("height")
        marginTop: @$elem.css("marginTop")
        marginRight: @$elem.css("marginRight")
        marginBottom: @$elem.css("marginBottom")
        marginLeft: @$elem.css("marginLeft")
        fontSize: @$elem.css("fontSize")
        borderRadius: @$elem.css("borderRadius")

      @$elem.wrap $("<div />").addClass(options.wrapperClass).css(wrapperCSS)

    # create strength meter
    @$elem.after "                <div class=\"" + options.strengthMeterClass + "\">                  <div data-meter=\"" + thisid + "\">Strength</div>                </div>"

    # create "show/hide" toggle and "text" verion of password field
    @$elem.after "                    <input style=\"display:none\" class=\"" + @$elem.attr("class") + options.strengthClass + "\" data-password=\"" + thisid + "\" type=\"text\" name=\"" + @$elem.attr("name") + "\" placeholder=\"" + @$elem.attr("placeholder") + "\" value=\"\" disabled=\"disabled\">                    <a data-password-button=\"" + thisid + "\" href=\"\" class=\"" + options.showHideButtonClass + "\">" + options.showHideButtonText + "</a>"  if options.showHide is true

    # events to trigger strength meter
    $(document).on "keyup", "input[data-password=\"" + thisid + "\"]", (event) ->
      thisval = $(this).val()
      $("input[data-password=\"" + thisid + "\"]").not($(this)).val thisval
      check_strength thisval, thisid
      return


    # events to trigger show/hide for password field
    if options.showHide is true
      $(document.body).on "click", "." + options.showHideButtonClass, (e) ->
        e.preventDefault()
        thisid = $(this).data("password-button")
        thisclass = "hide_" + $(this).attr("class")
        if isShown
          $("input[type=\"text\"][data-password=\"" + thisid + "\"]").prop("disabled", true).hide()
          $("input[type=\"password\"][data-password=\"" + thisid + "\"]").prop("disabled", false).show().focus()
          $("a[data-password-button=\"" + thisid + "\"]").removeClass(thisclass).html options.showHideButtonText
          isShown = false
        else
          $("input[type=\"text\"][data-password=\"" + thisid + "\"]").prop("disabled", false).show().focus()
          $("input[type=\"password\"][data-password=\"" + thisid + "\"]").prop("disabled", true).hide()
          $("a[data-password-button=\"" + thisid + "\"]").addClass(thisclass).html options.showHideButtonTextToggle
          isShown = true
        return

    return


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      $.data this, "plugin_" + pluginName, new Plugin(this, options)  unless $.data(this, "plugin_" + pluginName)
      return


  return
) jQuery, window, document
//= require_tree .

$ ->

  # Fastclick with tappy.js
  # $(document).on "tap", "a[href]:not(.in-page-link):not([href^='#'])", ->
  #   href = $(this).attr("href")
  #   if href.indexOf("#") isnt 0 && !$(this).hasClass("in-page-link")
  #   window.location.href = @href
  # $("a").each ->
  #   href = $(this).attr("href")
  #   if href.indexOf("#") isnt 0 && !$(this).hasClass("in-page-link")
  #     $(this).bind "tap", ->
  #       window.location.href = @href

  # Smooth scrolling to targets
  # scrollTime = 414
  # scrollElement = "html,body"
  # $(".in-page-link").on "tap", (event) ->
  #   event.preventDefault()
  #   $this = $(this)
  #   target = @hash
  #   $target = $(target)
  #   $(scrollElement).stop().animate
  #     scrollTop: $target.offset().top
  #   , scrollTime, "swing", ->
  #     #window.location.hash = target

  #
  # Config

  viewport = $(".viewport")
  canvas = $(".canvas")
  cardsContainer = $(".cards-container")

  baseTransitionTime = 0.333
  transitionEasing = "ease-out"

  #
  # Zoom-to-fit function

  zoomToFit = (target) ->
    # Fetch previous transform variables, if they exist
    if canvas.data("scale")
      currentScale = canvas.data("scale")
    else
      currentScale = 1

    if canvas.data("x")
      currentX = canvas.data("x")
    else
      currentX = 0

    if canvas.data("y")
      currentY = canvas.data("y")
    else
      currentY = 0

    # Pause any currently running transitions by giving canvas its own current transform values
    # currentCanvasStyles = window.getComputedStyle(canvas[0])
    # realCurrentTransform = currentCanvasStyles.getPropertyValue("-webkit-transform") || currentCanvasStyles.getPropertyValue("-moz-transform") || currentCanvasStyles.getPropertyValue("-o-transform") || currentCanvasStyles.getPropertyValue("-ms-transform") || currentCanvasStyles.getPropertyValue("transform")
    # canvas.css
    #   "-webkit-transition": "none"
    #   "-moz-transition":    "none"
    #   "-o-transition":      "none"
    #   "-ms-transition":     "none"
    #   "transition":         "none"
    #   "-webkit-transform": realCurrentTransform
    #   "-moz-transform":    realCurrentTransform
    #   "-o-transform":      realCurrentTransform
    #   "-ms-transform":     realCurrentTransform
    #   "transform":         realCurrentTransform

    # Calculate current viewport, canvas and target positions
    viewportWidth  = viewport[0].getBoundingClientRect().width
    viewportHeight = viewport[0].getBoundingClientRect().height
    canvasWidth    = canvas[0].getBoundingClientRect().width
    canvasHeight   = canvas[0].getBoundingClientRect().height
    targetWidth    = target[0].getBoundingClientRect().width  / currentScale
    targetHeight   = target[0].getBoundingClientRect().height / currentScale

    # Calculate new scale, canvas position and transition time
    scale = Math.min( viewportWidth/targetWidth, viewportHeight/targetHeight )
    x = Math.round( (target[0].getBoundingClientRect().left / currentScale) * -1 + currentX )
    y = Math.round( (target[0].getBoundingClientRect().top  / currentScale) * -1 + currentY )
    z = 0
    transitionTime = baseTransitionTime

    # Set new scale and canvas position
    canvas.css
      "-webkit-transition": "all #{transitionTime}s #{transitionEasing}"
      "-moz-transition":    "all #{transitionTime}s #{transitionEasing}"
      "-o-transition":      "all #{transitionTime}s #{transitionEasing}"
      "-ms-transition":     "all #{transitionTime}s #{transitionEasing}"
      "transition":         "all #{transitionTime}s #{transitionEasing}"
      "-webkit-transform": "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-moz-transform":    "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-o-transform":      "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-ms-transform":     "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "transform":         "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"

    console.log "------------------------------------------------"
    console.log target
    console.log "Fitting #{targetWidth}/#{targetHeight} into #{viewportWidth}/#{viewportHeight}"
    console.log "Current transform: #{currentScale}, #{currentX}px, #{currentY}px"
    console.log "New transform: #{scale}, #{x}px, #{y}px"
    console.log "During #{transitionTime}s with #{transitionEasing}"

    # Set .current-zoomable
    unless $(".current-zoomable")[0] == target
      $(".current-zoomable").removeClass("current-zoomable")
      target.addClass("current-zoomable")

    # Save transform variables for next transform
    canvas.data("scale", scale)
    canvas.data("x", x)
    canvas.data("y", y)

  #
  # Anchors on zoomables

  $(".zoomable-anchor").on "click", (event) ->
    event.preventDefault()
    zoomToFit( $(this).closest(".zoomable") )

  #
  # Zoom out button

  $("#zoom-out").on "click", (event) ->
    unless cardsContainer.hasClass("current-zoomable")
      if $(".current-zoomable").parent().closest(".zoomable").length > 0
        zoomToFit( $(".current-zoomable").parent().closest(".zoomable") )
      else
        zoomToFit( cardsContainer )

  #
  # Zoom out with ESC

  $(document).on "keyup", (event) ->
    if event.keyCode == 27
      $("#zoom-out").click()

  #
  # Rezoom on resize

  $(window).resize ->
    clearTimeout @resizeTO if @resizeTO
    @resizeTO = setTimeout(->
      $(this).trigger "resizeEnd"
    , 414)

  $(window).bind "resizeEnd", ->
    console.log "------------------------------------------------"
    console.log "Transforming again due to window resizing!"
    zoomToFit( $(".current-zoomable") )

  #
  # Init

  $("#zoom-out").click()

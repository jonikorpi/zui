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

  viewport = $(".viewport")
  canvas = $(".canvas")
  cardsContainer = $(".cards-container")

  zoomToFit = (target) ->
    currentScale = canvas.data("scale")
    currentY = canvas.data("y")
    currentX = canvas.data("x")

    viewportWidth  = viewport[0].getBoundingClientRect().width
    viewportHeight = viewport[0].getBoundingClientRect().height
    canvasWidth    = canvas[0].getBoundingClientRect().width  / currentScale
    canvasHeight   = canvas[0].getBoundingClientRect().height / currentScale
    targetWidth    = target[0].getBoundingClientRect().width  / currentScale
    targetHeight   = target[0].getBoundingClientRect().height / currentScale

    scale =        Math.min( viewportWidth/targetWidth, viewportHeight/targetHeight )

    x = Math.round((target[0].getBoundingClientRect().left / currentScale) * -1 + currentX)
    y = Math.round((target[0].getBoundingClientRect().top  / currentScale) * -1 + currentY)
    z = 0

    canvas.css
      "-webkit-transform": "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-moz-transform":    "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-o-transform":      "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-ms-transform":     "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "transform":         "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"

    console.log "--------------------------"
    console.log "Current transform: #{currentScale}, #{currentX}px, #{currentY}px"
    console.log target
    console.log "Fitting #{targetWidth}/#{targetHeight} to #{viewportWidth}/#{viewportHeight}"
    console.log "New transform: #{scale}, #{x}px, #{y}px"

    $(".current-zoomable").removeClass("current-zoomable")
    target.addClass("current-zoomable")

    canvas.data("scale", scale)
    canvas.data("x", x)
    canvas.data("y", y)

  $(".zoomable-anchor").on "click", (event) ->
    event.preventDefault()
    zoomToFit( $(this).closest(".zoomable") )

  $("#zoom-out").on "click", (event) ->
    unless cardsContainer.hasClass("current-zoomable")
      if $(".current-zoomable").parent().closest(".zoomable").length > 0
        zoomToFit( $(".current-zoomable").parent().closest(".zoomable") )
      else
        zoomToFit( cardsContainer )

  $("#zoom-out").click()

  $(document).on "keyup", (event) ->
    if event.keyCode == 27
      $("#zoom-out").click()

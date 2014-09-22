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
    viewportWidth  = viewport[0].getBoundingClientRect().width
    viewportHeight = viewport[0].getBoundingClientRect().height
    canvasWidth    = canvas[0].getBoundingClientRect().width
    canvasHeight   = canvas[0].getBoundingClientRect().height
    targetWidth    = target[0].getBoundingClientRect().width
    targetHeight   = target[0].getBoundingClientRect().height

    # currentScale = Math.min( viewportWidth/canvasWidth, viewportHeight/canvasHeight  )
    # scale = Math.min( viewportWidth/targetWidth, viewportHeight/targetHeight ) #/ currentScale

    currentScale = viewportWidth/canvasWidth
    scale = viewportWidth/targetWidth

    x = (target[0].getBoundingClientRect().left * scale) * -1
    y = (target[0].getBoundingClientRect().top  * scale) * -1
    z = 0

    $(".current-zoomable").removeClass("current-zoomable")
    target.addClass("current-zoomable")

    canvas.css
      "-webkit-transform": "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-moz-transform":    "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-o-transform":      "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-ms-transform":     "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "transform":         "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"

    console.log "Fitting #{targetWidth}/#{targetHeight} to #{viewportWidth}/#{viewportHeight}"
    console.log "currentScale is #{currentScale} and canvas is #{canvasWidth}/#{canvasHeight}"
    console.log "scale(#{scale}) translate3d(#{x}px, #{y}px, #{z}px)"

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
  $(".card-wrapper h1").each ->
    $(this).html( $(this).closest(".card")[0].getBoundingClientRect().width + "/" + $(this).closest(".card")[0].getBoundingClientRect().height )

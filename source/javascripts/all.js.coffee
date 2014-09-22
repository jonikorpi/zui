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
    if $(".current-zoomable").length > 0
      currentZoomable = $(".current-zoomable")
    else
      currentZoomable = viewport

    currentScale = Math.min( viewport.width() / currentZoomable.width(), viewport.height() / currentZoomable.height() )
    scale =        Math.min( viewport.width() / target.width(),          viewport.height() / target.height()          )

    x = (target.offset().left / currentScale) * -1
    y = (target.offset().top  / currentScale) * -1
    z = 0

    currentZoomable.removeClass("current-zoomable")
    target.addClass("current-zoomable")

    canvas.css
      "-webkit-transform": "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-moz-transform":    "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-o-transform":      "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "-ms-transform":     "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"
      "transform":         "scale3d(#{scale}, #{scale}, #{scale}) translate3d(#{x}px, #{y}px, #{z}px)"

    console.log "currentScale: " + currentScale
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

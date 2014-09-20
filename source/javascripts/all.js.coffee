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

  transformTo = (element, scale=1, y=0, x=0, z=0) ->
    element.css
      "-webkit-transform": "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
      "-moz-transform":    "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
      "-o-transform":      "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
      "-ms-transform":     "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
      "transform":         "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
    console.log "scale(#{scale}) translate3d(#{y}, #{x}, #{z})"
    #console.log element.css("-webkit-transform")
    console.log $(".canvas").data("scale")

  $("#birds-eye").on "click", (event) ->
    $("body").removeClass("birds-eye-mode panning-mode").addClass("birds-eye-mode")
    currentScale = $(".canvas").data("scale")
    scale = $(".viewport").width() / $(".canvas").width() * 0.944
    transformTo($(".canvas"), scale)
    $(".canvas").data("scale", scale)

  $("#panning, .panning-overlay-button").on "click", (event) ->
    $("body").removeClass("birds-eye-mode panning-mode").addClass("panning-mode")
    currentScale = $(".canvas").data("scale")
    scale = $(".viewport").width() / $(".card-wrapper").width() * 0.5
    x = "#{event.pageX / currentScale}px"
    y = "#{event.pageY / currentScale}px"
    transformTo($(".canvas"), scale)
    $(".canvas").data("scale", scale)

  $(".card-overlay-button").on "click", (event) ->
    $("body").removeClass("birds-eye-mode panning-mode")
    currentScale = $(".canvas").data("scale")
    scale = $(".viewport").width() / $(this).width()
    x = "#{$(this).closest(".card").offset().left / currentScale * -1}px"
    y = "#{$(this).closest(".card").offset().top / currentScale * -1}px"
    transformTo($(".canvas"), scale, x, y)
    $(".canvas").data("scale", scale)

  $("#birds-eye").click()

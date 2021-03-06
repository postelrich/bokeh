_ = require "underscore"
$ = require "jquery"
build_views = require "../common/build_views"
ContinuumView = require "../common/continuum_view"
BaseBox = require "./basebox"

class VBoxView extends ContinuumView
  tag: "div"
  attributes:
    class: "bk-vbox"

  initialize: (options) ->
    super(options)
    @views = {}
    @render()
    @listenTo(@model, 'change', @render)

  render: () ->
    children = @model.children()
    build_views(@views, children)
    for own key, val of @views
      val.$el.detach()
    @$el.empty()
    width = @mget("width")
    if width? then @$el.css(width: width + "px")
    height = @mget("height")
    if height?
      @$el.css(height: height + "px")
      spacer_height = height/(children.length*2)
    else
      spacer_height = 20

    spacer = $('<div>').addClass('bk-vbox-spacer').css({height: spacer_height})
    @$el.append($(spacer))
    for child in children
      @$el.append(@views[child.id].$el)

      @$el.append($(spacer))

    return @

class VBox extends BaseBox.Model
  type: "VBox"
  default_view: VBoxView

  defaults: ->
    return _.extend {}, super(), {
      children: []
    }

  children: () ->
    return @get('children')

module.exports =
  Model: VBox
  View: VBoxView

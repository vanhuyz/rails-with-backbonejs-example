class App.Views.Todo extends Backbone.View
  tagName: 'li'
  template: JST['templates/todo']
  render: ->
    @$el.html @template(@model.toJSON())
    @input = @$('.edit')
    this
  initialize: ->
    @model.on 'change', @render, this
    @model.on 'destroy', @remove, this
  events:
    'dblclick label': 'edit'
    'keypress .edit': 'updateOnEnter'
    'blur .edit': 'close'
    'click .toggle': 'toggleCompleted'
    'click .destroy': 'destroy'
  edit: ->
    @$el.addClass 'editing'
    @input.focus()
  close: ->
    value = @input.val().trim()
    if value
      @model.save title: value
    @$el.removeClass 'editing'
  updateOnEnter: (e) ->
    if e.which == 13
      @close()
  toggleCompleted: ->
    @model.toggle()
  destroy: ->
    @model.destroy()
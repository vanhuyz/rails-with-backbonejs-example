class @App.Models.Todo extends Backbone.Model
  defaults:
    title: ''
    completed: false
  rootUrl: 'todos'
  toggle: ->
    @save completed: !@get('completed')
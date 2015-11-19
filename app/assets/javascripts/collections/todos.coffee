class App.Collections.Todos extends Backbone.Collection
  model: App.Models.Todo
  url: 'todos'
  completed: ->
    @filter (todo) ->
      todo.get 'completed'
  remaining: ->
    @without.apply this, @completed()

App.todos = new (App.Collections.Todos)
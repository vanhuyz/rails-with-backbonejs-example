class App.Views.Index extends Backbone.View
  el: '#todoapp'
  initialize: ->
    @input = @$('#new-todo')
    App.todos.on 'add', @addOne, this
    App.todos.on 'reset', @addAll, this
    App.todos.fetch(reset: true)
  events: 
    'keypress #new-todo': 'createTodoOnEnter'
  createTodoOnEnter: (e) ->
    return if e.which != 13 or !@input.val().trim() # ENTER_KEY = 13
    App.todos.create @newAttributes()
    @input.val ''
  addOne: (todo) ->
    view = new (App.Views.Todo)(model: todo)
    $('#todo-list').append view.render().el
  addAll: ->
    @$('#todo-list').html ''
    switch App.TodoFilter
      when 'pending'
        _.each App.todos.remaining(), @addOne
      when 'completed'
        _.each App.todos.completed(), @addOne
      else
        App.todos.each @addOne, this
        break
  newAttributes: ->
    {
      title: @input.val().trim()
      completed: false
    }
ready = ->
  'use strict'
  app = {}
  # create namespace for our app
  #--------------
  # Models
  #--------------
  app.Todo = Backbone.Model.extend(
    defaults:
      title: ''
      completed: false
    rootUrl: 'todos'
    toggle: ->
      @save completed: !@get('completed')
  )
  #--------------
  # Collections
  #--------------
  app.TodoList = Backbone.Collection.extend(
    model: app.Todo
    url: 'todos'
    completed: ->
      @filter (todo) ->
        todo.get 'completed'
    remaining: ->
      @without.apply this, @completed()
  )
  # instance of the Collection
  app.todoList = new (app.TodoList)
  #--------------
  # Views
  #--------------
  app.TodoView = Backbone.View.extend(
    tagName: 'li'
    template: _.template('<div class="view">
        <input class="toggle" type="checkbox" <%= completed ? "checked" : "" %>>
        <label><%- title %></label>
        <input class="edit" value="<%- title %>">
        <button class="destroy">remove</button>
      </div>')
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
  )
  # renders the full list of todo items calling TodoView for each one.
  app.AppView = Backbone.View.extend(
    el: '#todoapp'
    initialize: ->
      @input = @$('#new-todo')
      app.todoList.on 'add', @addOne, this
      app.todoList.on 'reset', @addAll, this
      app.todoList.fetch()
    events: 
      'keypress #new-todo': 'createTodoOnEnter'
    createTodoOnEnter: (e) ->
      return if e.which != 13 or !@input.val().trim() # ENTER_KEY = 13
      app.todoList.create @newAttributes()
      @input.val ''
    addOne: (todo) ->
      view = new (app.TodoView)(model: todo)
      $('#todo-list').append view.render().el
    addAll: ->
      @$('#todo-list').html ''
      switch window.filter
        when 'pending'
          _.each app.todoList.remaining(), @addOne
        when 'completed'
          _.each app.todoList.completed(), @addOne
        else
          app.todoList.each @addOne, this
          break
    newAttributes: ->
      {
        title: @input.val().trim()
        completed: false
      }
  )
  #--------------
  # Routers
  #--------------
  app.Router = Backbone.Router.extend(
    routes: '*filter': 'setFilter'
    setFilter: (params) ->
      console.log 'app.router.params = ' + params
      window.filter =  if params? then params.trim() else ''
      app.todoList.trigger 'reset'
  )
  #--------------
  # Initializers
  #--------------   
  app.router = new (app.Router)
  Backbone.history.start()
  app.appView = new (app.AppView)

$(document).ready(ready)
$(document).on('page:load', ready)

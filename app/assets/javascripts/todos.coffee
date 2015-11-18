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
    url: 'todos'
    toggle: ->
      @save completed: !@get('completed'), { patch: true }
      return
  )
  #--------------
  # Collections
  #--------------
  app.TodoList = Backbone.Collection.extend(
    model: app.Todo
    # localStorage: new Store('backbone-todo')
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
  # renders individual todo items list (li)
  app.TodoView = Backbone.View.extend(
    tagName: 'li'
    # template: _.template($('#item-template').html())
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
      # enable chained calls
    initialize: ->
      @model.on 'change', @render, this
      @model.on 'destroy', @remove, this
      # remove: Convenience Backbone's function for removing the view from the DOM.
      return
    events:
      'dblclick label': 'edit'
      'keypress .edit': 'updateOnEnter'
      'blur .edit': 'close'
      'click .toggle': 'toggleCompleted'
      'click .destroy': 'destroy'
    edit: ->
      @$el.addClass 'editing'
      @input.focus()
      return
    close: ->
      value = @input.val().trim()
      if value
        @model.save title: value, { patch: true }
      @$el.removeClass 'editing'
      return
    updateOnEnter: (e) ->
      if e.which == 13
        @close()
      return
    toggleCompleted: ->
      @model.toggle()
      return
    destroy: ->
      @model.destroy()
      return
  )
  # renders the full list of todo items calling TodoView for each one.
  app.AppView = Backbone.View.extend(
    el: '#todoapp'
    initialize: ->
      @input = @$('#new-todo')
      app.todoList.on 'add', @addAll, this
      app.todoList.on 'reset', @addAll, this
      app.todoList.fetch(reset: true)
      # console.log @$el
      # Loads list from local storage
      return
    events: 
      'keypress #new-todo': 'createTodoOnEnter'
    createTodoOnEnter: (e) ->
      if e.which != 13 or !@input.val().trim()
        # ENTER_KEY = 13
        return
      app.todoList.create @newAttributes()
      @input.val ''
      # clean input box
      return
    addOne: (todo) ->
      view = new (app.TodoView)(model: todo)
      $('#todo-list').append view.render().el
      return
    addAll: ->
      @$('#todo-list').html ''
      app.todoList.each @addOne, this
      # clean the todo list
      # filter todo item list
      # switch window.filter
      #   when 'pending'
      #     _.each app.todoList.remaining(), @addOne
      #   when 'completed'
      #     _.each app.todoList.completed(), @addOne
      #   else
      #     app.todoList.each @addOne, this
      #     break
      return
    newAttributes: ->
      {
        title: @input.val().trim()
        completed: false
      }
  )
  #--------------
  # Routers
  #--------------
  # app.Router = Backbone.Router.extend(
  #   routes: '*filter': 'setFilter'
  #   setFilter: (params) ->
  #     console.log 'app.router.params = ' + params
  #     # window.filter = params.trim() or ''
  #     app.todoList.trigger 'reset'
  #     return
  # )
  #--------------
  # Initializers
  #--------------   
  #app.router = new (app.Router)
  #Backbone.history.start()
  app.appView = new (app.AppView)

$(document).ready(ready)
$(document).on('page:load', ready)

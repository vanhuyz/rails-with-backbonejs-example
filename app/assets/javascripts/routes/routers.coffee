class App.Routers.Todos extends Backbone.Router
  routes: 
    '*filter': 'setFilter'

  setFilter: (params) ->
    console.log 'app.router.params = ' + params
    App.TodoFilter =  params || ''
    App.todos.trigger 'reset'

App.TodoRouter = new App.Routers.Todos
Backbone.history.start()
#= require_self
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routes

'use strict'

@App =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  new (App.Views.Index)

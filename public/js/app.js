define([ 'jquery'
       , 'underscore'
       , 'backbone'
       , 'routers/reagent-router'
       ],

function($, _, Backbone, ReagentRouter){

  var initialize = function(){
    ReagentRouter.initialize();
    Backbone.history.start();
  };

  return { initialize: initialize };
});
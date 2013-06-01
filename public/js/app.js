define([ 'jquery'
       , 'underscore'
       , 'backbone'
       , 'routers/reagentRouter'
       ],

function($, _, Backbone, ReagentRouter){

  var initialize = function(){
    ReagentRouter.initialize();
    Backbone.history.start();
  };

  return { initialize: initialize };
});
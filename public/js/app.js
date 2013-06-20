define([ 'backbone'
       , 'routers/reagent-router'
       ],

function(Backbone, ReagentRouter){

  var initialize = function(){
    ReagentRouter.initialize();
    Backbone.history.start();
  };

  return { initialize: initialize };
});

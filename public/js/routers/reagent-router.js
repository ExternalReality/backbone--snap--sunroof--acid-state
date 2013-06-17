define([ 'backbone'
       , 'views/reagent-list-view'
       , 'views/reagent-input-view'
       ],

function(Backbone, ReagentListView, ReagentInputView){
  var ReagentRouter = Backbone.Router.extend({
    routes: { 'reagents'     : 'showReagents'
            , 'reagentInput' : 'inputReagent'
            }
  });

  var initialize = function(){
    var reagent_router = new ReagentRouter();

    reagent_router.on('route:showReagents', function(){
      var content = $('#container');
      var reagentListView = new ReagentListView();
      reagentListView.render().$el.appendTo(content);
    });

    reagent_router.on('route:inputReagent', function(){
      var content = $('#container');
      var reagentInputView = new ReagentInputView();
      reagentInputView.render().$el.appendTo(content);
    });

  };

  return { initialize: initialize };
});
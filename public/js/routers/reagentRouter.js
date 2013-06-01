define([ 'backbone'
       , 'views/ReagentListView'
       ],

function(Backbone, ReagentListView){
  var ReagentRouter = Backbone.Router.extend({
    routes: { 'reagents' : 'showReagents'}
  });

  var initialize = function(){
    var reagent_router = new ReagentRouter();

    reagent_router.on('route:showReagents', function(){
      var content = $('#container');
      var reagentListView = new ReagentListView();
      reagentListView.render().$el.appendTo(content);
    });
  };

  return { initialize: initialize };
});
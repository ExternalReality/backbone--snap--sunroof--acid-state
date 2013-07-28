define([ 'backbone'
       , 'views/laboratory-view'
       , 'views/reagent-input-view'
       ],

function( Backbone 
	, LaboratoryView
	){
    
  var ReagentRouter = Backbone.Router.extend({
  routes: { 'laboratory'   : 'laboratory'
          , 'reagentInput' : 'inputReagent'
          }
  });

  var initialize = function(laboratoryView, reagentInputView){
    var reagent_router = new ReagentRouter();

    reagent_router.on('route:laboratory', function(){
      var content = $('#content');

      var laboratoryElement = laboratoryView.render().el;
      content.append(laboratoryElement);
    });

    reagent_router.on('route:inputReagent', function(){
      var content = $('#content');
      reagentInputView.render().$el.appendTo(content);
    });

  };

  return { initialize: initialize };
});

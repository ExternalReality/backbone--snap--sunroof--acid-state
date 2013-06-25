define([ 'backbone'
       , 'views/laboratory-view'
       , 'views/reagent-input-view'
       ],

function( Backbone 
	, LaboratoryView
	, ReagentInputView
	){
    
  var ReagentRouter = Backbone.Router.extend({
  routes: { 'laboratory'   : 'laboratory'
          , 'reagentInput' : 'inputReagent'
          }
  });

  var initialize = function(){
    var reagent_router = new ReagentRouter();

    reagent_router.on('route:laboratory', function(){
      var content = $('#content');
      var laboratoryView = new LaboratoryView();
      var laboratory = laboratoryView.render().el;
      content.append(laboratory);
    });

    reagent_router.on('route:inputReagent', function(){
      var content = $('#content');
      var reagentInputView = new ReagentInputView();
      reagentInputView.render().$el.appendTo(content);
    });

  };

  return { initialize: initialize };
});

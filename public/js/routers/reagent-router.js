define([ 'backbone'
       , 'backbone-extentions/router-utilities'
       ],

function( Backbone 
	, RouterUtils
	){
    
  var ReagentRouter = Backbone.Router.extend({

    routes: { 'laboratory'   : 'laboratory'
            , 'reagentInput' : 'inputReagent'
            },

    initialize : function(laboratoryView, reagentInputView){
      this.laboratoryView   = laboratoryView;
      this.reagentInputView = reagentInputView;
      this.routeChangeObservable = RouterUtils.createObservable('route:laboratory', this);
    },

    run : function(){
      this.on('route:laboratory',   function(){RouterUtils.openView(this.laboratoryView);});
      this.on('route:inputReagent', function(){RouterUtils.replaceContentWith(this.reagentInputView);});
      }
  });

  return ReagentRouter;
});

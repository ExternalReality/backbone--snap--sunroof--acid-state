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

    initialize : function(laboratoryView, reagentInputView)
    {
      this.laboratoryView   = laboratoryView;
      this.reagentInputView = reagentInputView;
    },

    run : function(){       
      this.on('route:laboratory',   RouterUtils.replaceContentWith(this.laboratoryView));
      this.on('route:inputReagent', RouterUtils.replaceContentWith(this.reagentInputView));
      }
  });

  return ReagentRouter;
});

define([ 'backbone'
       , 'views/potionmakers-mixture-view'
       , 'backbone-extentions/router-utilities'
       ],

function( Backbone 
	, PotionMakersMixturesView
	, RouterUtils
	){
    
  var MixtureRouter = Backbone.Router.extend({
    
    routes: { 'potionMakersMixtures' : 'potionMakersMixtures' },

    initialize : function(potionMakersMixturesView){
      this.potionMakersMixturesView    = potionMakersMixturesView;
      this.potionMakersMixturesHandler = RouterUtils.replaceContentWith(this.potionMakersMixturesView);
    },
       
    run : function(){      
      this.on('route:potionMakersMixtures', this.potionMakersMixturesHandler); 
    }
  });

  return MixtureRouter;					   

});

define([ 'backbone'       
       , 'rx'	 
       , 'routers/reagent-router'
       , 'routers/mixture-router'
       , 'views/reagent-list-view'
       , 'views/soap-creation-view'
       , 'views/laboratory-view'
       , 'views/reagent-input-view'
       , 'views/potionmakers-mixture-view' 
       , 'models/reagent-model'
       , 'collections/reagent-collection'
       , 'models/mixture'
       , 'views/mixture-view'
       , 'models/reagent-model'
       , 'bootstrap'
       ],

function( Backbone
	, Rx 
	, ReagentRouter
	, MixtureRouter
        , ReagentListView
	, SoapCreationView
        , LaboratoryView
	, ReagentInputView
        , PotionMakersMixturesView
        , Reagent
	, Reagents
	, Mixture
	, MixtureView
        , ReagentModel
	){
   
  var bootstrapedReagents      = new Reagents(self.reagents);
  var bootstrapedMixtures      = _.map(self.mixtures, function(mixtureData){ return new Mixture(mixtureData); });  
  var mixtureViews             = _.map(bootstrapedMixtures, function(mixture){ return new MixtureView(mixture); });

  var reagentModel             = new ReagentModel();
  var reagentCollection        = new Reagents();
  var reagentInputView         = new ReagentInputView(reagentModel, reagentCollection);

  var mixture                  = new Mixture();
  var soapCreateionView        = new SoapCreationView(mixture);
  var reagentListView          = new ReagentListView(bootstrapedReagents);
  var laboratoryView           = new LaboratoryView(reagentListView, soapCreateionView);

  var potionMakersMixturesView = new PotionMakersMixturesView(mixtureViews);

  var reagentRouter            = new ReagentRouter(laboratoryView, reagentInputView);
  var mixtureRouter            = new MixtureRouter(potionMakersMixturesView);
 
  mixtureRouter.routeChangeObservable
	       .subscribe(laboratoryView.changeRouteObserver);

  reagentRouter.routeChangeObservable
	       .subscribe(potionMakersMixturesView.changeRouteObserver);

  var initialize = function(){    
    reagentRouter.run();
    mixtureRouter.run();
    Backbone.history.start();
  };

  return { initialize: initialize };
});

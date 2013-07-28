define([ 'backbone'       
       , 'routers/reagent-router'
       , 'routers/mixture-router'
       , 'views/reagent-list-view'
       , 'views/mixture-view'
       , 'views/laboratory-view'
       , 'views/reagent-input-view'
       , 'views/potionmakers-mixture-view' 
       , 'models/reagent-model'
       , 'collections/reagents'
       , 'collections/mixture'
       ],

function( Backbone
	, ReagentRouter
	, MixtureRouter
        , ReagentListView
	, MixtureView 
        , LaboratoryView
	, ReagentInputView
        , PotionMakersMixturesView
        , Reagent
	, Reagents
	, Mixture
	){

  var reagentModel             = new Reagent();
  var reagentCollection        = new Reagents();
  var reagentInputView         = new ReagentInputView(reagentModel, reagentCollection);

  var mixture                  = new Mixture();
  var mixtureView              = new MixtureView(mixture);
  var reagentListView          = new ReagentListView();
  var laboratoryView           = new LaboratoryView(reagentListView, mixtureView);

  var potionMakersMixturesView = new PotionMakersMixturesView();

  var reagentRouter            = new ReagentRouter(laboratoryView, reagentInputView);
  var mixtureRouter            = new MixtureRouter(potionMakersMixturesView);
  

  var initialize = function(){
    reagentRouter.run();
    mixtureRouter.run();
    Backbone.history.start();
  };

  return { initialize: initialize };
});

define([ 'backbone'       
       , 'routers/reagent-router'
       , 'routers/mixture-router'
       , 'views/reagent-list-view'
       , 'views/mixture-view'
       , 'views/laboratory-view'
       , 'views/reagent-input-view'
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
        , Reagent
	, Reagents
	, Mixture
	){

  var reagentModel      = new Reagent();
  var reagentCollection = new Reagents();
  var mixture           = new Mixture();

  var reagentListView  = new ReagentListView();
  var mixtureView      = new MixtureView(mixture);
  var reagentInputView = new ReagentInputView(reagentModel, reagentCollection);
  var laboratoryView   = new LaboratoryView(reagentListView, mixtureView);

  var initialize = function(){
    ReagentRouter.initialize(laboratoryView, reagentInputView);
    MixtureRouter.initialize();
    Backbone.history.start();
  };

  return { initialize: initialize };
});

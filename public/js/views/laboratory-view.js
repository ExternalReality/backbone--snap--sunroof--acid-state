define([ 'backbone'
       , 'rx'  
       , 'views/reagent-list-view'
       , 'views/soap-creation-view'
       , 'text!/../templates/laboratory.html'
       , 'backbone-extentions/view-utilities'	 
       , 'backbone-extentions/view-extentions'
       ],

function( Backbone
	, Rx  
	, ReagentListView
	, SoapCreateionView
    	, LaboratoryTemplate
	, ViewUtils
	){

  var LaboratoryView = Backbone.View.extend({

    initialize : function(reagentListView, soapCreationView) {
      this.reagentList         = reagentListView;
      this.soapCreationView    = soapCreationView;
      this.changeRouteObserver = ViewUtils.createRouteChangeObserver(this);
      this.listenTo(this.reagentList, "iconClicked", this.addToMixture);
    },

    addToMixture : function(args) {
      this.soapCreationView.addReagent(args);
    },
    
    render: function() {
       
      this.renderTemplate(LaboratoryTemplate, {});

      var reagentListElement  = this.reagentList.render().el;
      var soapCreationElement = this.soapCreationView.render().el;

      this.$('.reagents').replaceWith(reagentListElement);
      this.$('.soap').replaceWith(soapCreationElement);

      return this;
    }   

  });

  return LaboratoryView;

});

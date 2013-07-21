define([ 'backbone'
       , 'views/reagent-list-view'
       , 'views/mixture-view'
       , 'text!/../templates/laboratory.html'
       ],

function( Backbone
	, ReagentListView
	, MixtureView
	, LaboratoryTemplate
	){

  var LaboratoryView = Backbone.View.extend({

    initialize : function() {
      this.reagentList = new ReagentListView();
      this.mixture     = new MixtureView();

      this.listenTo(this.reagentList, "iconClicked", this.addToMixture);
    },

    addToMixture : function(args) {
      this.mixture.addReagent(args);
    },

    render: function() {
       
      var template = _.template(LaboratoryTemplate, {});
      this.$el.html(template);
      this.setElement(template);

      var reagentListElement = this.reagentList.render().el;
      var mixtureElement     = this.mixture.render().el;

      this.$('.reagents').replaceWith(reagentListElement);
      this.$('.mixture').replaceWith(mixtureElement);

      return this;
    }

  });

  return LaboratoryView;

});

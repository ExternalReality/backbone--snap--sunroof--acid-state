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

    render: function() {
       
      var template = _.template(LaboratoryTemplate, {});
      this.$el.html(template);
      this.setElement(template);

      var reagents = new ReagentListView().render().el;
      var mixture  = new MixtureView().render().el;

      this.$('.reagents').replaceWith(reagents);
      this.$('.mixture').replaceWith(mixture);

      return this;
    }

  });

  return LaboratoryView;

});

define([ 'backbone'
       , 'models/reagent-model'
       , 'text!/../templates/reagent_template.html'
       , 'backbone-extentions/view-extentions'
       ],

function(Backbone, ReagentModel, ReagentTemplate){
    var ReagentView = Backbone.View.extend({

      initialize : function (reagent){
	this.model = reagent;
      },

      render: function() {
	var name = this.model.name;
	this.renderTemplate(ReagentTemplate, { name : name } );
	return this;
      }
  });

  return ReagentView;
});

define([ 'backbone'
       , 'models/reagentModel'
	 //fix-me this shouldn't have to mention PotionSoapClient it should be relative to templates.
       , 'text!/PotionSoapClient/templates/reagent.html'
       ],

function(Backbone, ReagentModel, ReagentTemplate){
    var ReagentView = Backbone.View.extend({

      initialize : function (){
	this.model = new ReagentModel({'id' : '1'});
	this.model.fetch();

	this.listenTo(this.model, "change", this.render);
      },

      render: function() {
	var name = this.model.get("name");
	var template = _.template(ReagentTemplate, { name : name } );
	$(this.el).html(template);
	return this;
      }
  });

  return ReagentView;
});
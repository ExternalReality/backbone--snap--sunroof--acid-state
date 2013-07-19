define([ 'backbone'
       , 'models/reagent-model'
       , 'text!/../templates/reagent_icon_template.html'
       , 'bootstrap'
       , 'jquery.ui'
       ],

function(Backbone, ReagentModel, ReagentIconTemplate){
  var ReagentIconView = Backbone.View.extend({

    initialize: function(){
      this.model = this.options.model;
    },

    templateBindings: function (){
      return { reagentName      : this.model.get("name")
	     , imageUrl         : this.model.get("imageUrl")
	     , imageNotFoundUrl : "images/reagent-icons/unavailable/imageNotFoundUrl"
	     };
    },

    render: function(){
      var template = _.template(ReagentIconTemplate, this.templateBindings() );
      this.$el.html(template);
      this.setElement(template);
      this.$('.reagent-icon').tooltip();
      return this;
    }
  });

  return ReagentIconView;
});

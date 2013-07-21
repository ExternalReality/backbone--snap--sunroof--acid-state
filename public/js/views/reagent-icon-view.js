define([ 'backbone'
       , 'models/reagent-model'
       , 'text!/../templates/reagent_icon_template.html'
       , 'bootstrap'
       ],

function(Backbone, ReagentModel, ReagentIconTemplate){
  var ReagentIconView = Backbone.View.extend({
    
    events : { 'click' : 'iconClicked' }, 
    
    initialize: function(){
      this.model = this.options.model;
    },

    iconClicked : function() {
      this.trigger("icon-clicked", this.model);
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
      return this;
    }
  });

  return ReagentIconView;
});

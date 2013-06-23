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
      return {
        reagentName : this.model.get("name")
      };
    },

    render: function() {
      var template = _.template(ReagentIconTemplate, this.templateBindings() );
      this.$el.html(template);
      this.setElement(template);
      this.$('.reagent-icon').draggable();
      return this;
    }
  });

  return ReagentIconView;
});

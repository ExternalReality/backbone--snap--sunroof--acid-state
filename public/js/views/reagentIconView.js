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

    render: function() {
      var template = _.template(ReagentIconTemplate, {reagentName : this.model.get("name")} );
      this.$el.html(template);
      this.setElement(template);
      this.$('.reagent-icon').draggable();
      return this;
    }
  });

  return ReagentIconView;
});

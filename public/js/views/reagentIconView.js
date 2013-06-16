define([ 'backbone'
       , 'models/reagentModel'
       , 'text!/../templates/reagent_icon_template.html'
       , 'bootstrap'
       , 'jqueryui'
       ],

function(Backbone, ReagentModel, ReagentIconTemplate){
  var ReagentIconView = Backbone.View.extend({

    initialize: function(){
      this.model = this.options.model;
    },

    render: function() {
      var template = _.template(ReagentIconTemplate, {reagentName : this.model.get("name")} );
      this.$el.html(template);
      this.$el.draggable();
      this.$el.addClass("reagent");
      return this;
    }
  });

  return ReagentIconView;
});
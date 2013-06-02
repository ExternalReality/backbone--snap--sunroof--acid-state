define([ 'backbone'
       , 'collections/reagents'
       , 'text!/../templates/reagents_template.html'
       , 'bootstrap'
       ],

function(Backbone, Reagents, ReagentsTemplate){
  var ReagentListView = Backbone.View.extend({
    initialize: function(){

      //reagents is bound by the bootstrap script loaded in the above require.js list
      this.collection = new Reagents(reagents);
      this.listenTo(this.collection, "change", this.render);

    },

    render: function() {
      var template = _.template(ReagentsTemplate, {reagents : this.collection.models} );
      this.$el.html(template);
      console.log("I renered");
      return this;
    }
  });

  return ReagentListView;
});

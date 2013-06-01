define([ 'backbone'
       , 'collections/reagents'
       , 'text!/../templates/reagents.html'
       ],

function(Backbone, Reagents, ReagentsTemplate){
  var ReagentListView = Backbone.View.extend({
    initialize: function(){
      this.collection = new Reagents();
      this.collection.fetch();
      this.listenTo(this.collection, "change", this.render);
    },


    render: function() {
      var template = _.template(ReagentsTemplate, { reagents : this.collection.models} );
      this.$el.html(template);
      console.log("I renered");
      return this;
    }
  });

  return ReagentListView;
});

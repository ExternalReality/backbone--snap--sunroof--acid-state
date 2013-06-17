define([ 'backbone'
       , 'collections/reagents'
       , 'views/reagentIconView'
       , 'text!/../templates/reagents_template.html'
       , 'bootstrap'
       ],

function(Backbone, Reagents, ReagentIconView, ReagentsTemplate){
  var ReagentListView = Backbone.View.extend({

    initialize: function(){

      //reagents is bound by the bootstrap script loaded in the above require.js list
      this.collection = new Reagents(reagents);
      this.listenTo(this.collection, "change", this.render);
      this.listenTo(this.collection, "add", this.render);

      var fetchOnInterval = function() { this.collection.fetch() };
      fetchOnInterval = _.bind(fetchOnInterval, this);
      setInterval(fetchOnInterval, 10000);
    },

    render: function() {
      var template = _.template(ReagentsTemplate);
      this.$el.html(template);

      var models = this.collection.models;
      _.each(models, this.renderReagentIcons, this);

      return this;
    },

    renderReagentIcons : function(model) {
      var reagentIconView = new ReagentIconView({model : model});
      var reagentIcon = reagentIconView.render();
      this.$('ul').append(reagentIcon.el);

      return this;
    }

  });

  return ReagentListView;
});
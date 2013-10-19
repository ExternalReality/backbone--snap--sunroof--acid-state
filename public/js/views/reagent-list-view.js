define([ 'backbone'
       , 'collections/reagent-collection'
       , 'foo'
       , 'text!/../templates/reagents_table_template.html'
       ],

function( Backbone
	, Reagents
	, ReagentIconView
	, ReagentsTemplate
        ){

  var ReagentListView = Backbone.View.extend({

    initialize: function(reagents){

      this.collection = reagents;

      this.listenTo(this.collection, "change", this.render);
      this.listenTo(this.collection, "add", this.render);

      var fetchOnInterval = function() { this.collection.fetch(); };
      fetchOnInterval = _.bind(fetchOnInterval, this);
      self.setInterval(fetchOnInterval, 10000000);     
    },

    iconClicked : function(args){
      this.trigger("iconClicked", args); 
    },

    render: function() {
      var template = _.template(ReagentsTemplate,{});
      this.$el.html(template);
      this.setElement(template);

     var reagentModels = this.collection.models;

      var iconViews = _.map(reagentModels, this.toIconView, this);
      _.each(iconViews, function(elem){this.$el.append(elem);}, this);
      return this;
    },

    toIconView : function(reagent) {
      var reagentIconView = new ReagentIconView({model : reagent});
      this.listenTo(reagentIconView, "icon-clicked", this.iconClicked);
      reagentIconView.render();
      return reagentIconView.el;
    }

  });

  return ReagentListView;
});

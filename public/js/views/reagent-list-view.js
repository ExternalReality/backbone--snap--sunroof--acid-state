define([ 'backbone'
       , 'collections/reagents'
       , 'views/reagent-icon-view'
       , 'text!/../templates/reagents_table_template.html'
       , 'bootstrap'
       ],

function( Backbone
	, Reagents
	, ReagentIconView
	, ReagentsTemplate
    ){

  var ReagentListView = Backbone.View.extend({

    initialize: function(){

      /*  The variable reagents is bound by the bootstrap script 
       *  loaded in the above require.js list and is populated with
       *  reagents by the server when the application starts.
       */

      this.collection = new Reagents(self.reagents);

      this.listenTo(this.collection, "change", this.render);
      this.listenTo(this.collection, "add", this.render);

      var fetchOnInterval = function() { this.collection.fetch(); };
      fetchOnInterval = _.bind(fetchOnInterval, this);
      self.setInterval(fetchOnInterval, 10000);     
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
      this.listenToOnce(reagentIconView, "icon-clicked", this.iconClicked);
      var reagentIconHtmlElement = reagentIconView.render().el;
      return reagentIconHtmlElement;
    }

  });

  return ReagentListView;
});

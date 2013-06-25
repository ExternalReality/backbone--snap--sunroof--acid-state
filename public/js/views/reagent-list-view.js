define([ 'backbone'
       , 'collections/reagents'
       , 'views/reagent-icon-view'
       , 'text!/../templates/reagents_table_template.html'
       , 'bootstrap'
       ],

function( Backbone
	, Reagents
	, ReagentIconView
	, ReagentsTemplate ){

  var ReagentListView = Backbone.View.extend({

    initialize: function(){

      //The variable reagents is bound by the bootstrap script loaded in the above require.js list
      this.collection = new Reagents(self.reagents);
      this.listenTo(this.collection, "change", this.render);
      this.listenTo(this.collection, "add", this.render);

      var fetchOnInterval = function() { this.collection.fetch(); };
      fetchOnInterval = _.bind(fetchOnInterval, this);
      self.setInterval(fetchOnInterval, 10000);
    },

    render: function() {
      var template = _.template(ReagentsTemplate,{});
      this.$el.html(template);
      this.setElement(template);

      var reagentModels = this.collection.models;

      var COLS = 3;
      var tableCells = _.map(reagentModels, this.toHtmlTableCellRepresentation);
      var tableElements = this.intersperseAfterPos(COLS,"<tr/>",tableCells);
      _.each(tableElements, function(elem){this.$(".body").append(elem);}, this); 

      return this;
    },

    intersperseAfterPos : function (pos, el, ls) {
      var result = [];
      var m = false;
      for(var i = 0; i < ls.length; i++){
	  m =  (i % pos) == pos - 1 ;
	  m ? result = result.concat([ls[i],el]) : result = result.concat(ls[i]);	  
      }
      return result;
    }, 

    toHtmlTableCellRepresentation : function(reagent) {
      var reagentIconView = new ReagentIconView({model : reagent});
      var reagentIconHtmlElement = reagentIconView.render().el;
      return reagentIconHtmlElement;
    }

  });

  return ReagentListView;
});

define (['backbone'
	, 'text!/../templates/mixture.html'
	, 'views/reagent-view'
        ],    

function ( Backbone, MixtureTemplate, ReagentView ) {

  var MixtureView = Backbone.View.extend({

  initialize : function (mixture){
    this.mixture = mixture;
    this.reagentsViews = _.map(mixture.reagents(),function(reagent){return new ReagentView(reagent);});
  },
    
  render : function(){
    this.renderTemplate(MixtureTemplate, {});    
    if (this.mixture.reagents().length > 0){ this.renderReagents();};
    return this;
    
  },

  renderReagents : function () {
    var reagentElements = _.map(this.reagentsViews, function(view){ return view.render(); });    
    var renderFn = _.bind(function(view){view.$el.appendTo(this.el);}, this);
    _.each(reagentElements, renderFn);
  }
  
  });
  
  return MixtureView;
  
});

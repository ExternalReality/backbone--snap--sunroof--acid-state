define([ 'backbone'
       , 'rx'
       , 'backbone-extentions/view-utilities'	 	 
       , 'text!/../templates/potion_makers_mixtures_template.html'
       ],

function(Backbone
	, Rx
	, ViewUtils
	, PotionMakersMixturesTemplate
	){

  var PotionMakersMixturesView = Backbone.View.extend({
    initialize : function(mixturesViews){
      this.changeRouteObserver = ViewUtils.createRouteChangeObserver(this);
      this.mixtureViews = mixturesViews;
    },

    render: function() {
      this.renderTemplate(PotionMakersMixturesTemplate, {});
      this.renderMixtureViews();
      return this;
    },

    createMixtureElements : function(){
      return  _.map(this.mixtureViews, function(mixtureView){return mixtureView.render();});
    },

    renderMixtureViews : function(){
     var mixtureElements = this.createMixtureElements();
     var renderFn = _.bind(function(mixtureElement){mixtureElement.$el.appendTo(this.el);}, this);     
     _.map(mixtureElements, renderFn);
    }
    
  });

  return PotionMakersMixturesView;
});

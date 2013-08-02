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
    initialize : function(){
      this.changeRouteObserver = ViewUtils.createRouteChangeObserver(this);
    },


    render: function() {
      this.renderTemplate(PotionMakersMixturesTemplate, {});
      return this;
    }
  });

  return PotionMakersMixturesView;
});

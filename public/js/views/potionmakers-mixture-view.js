define([ 'backbone'
       , 'text!/../templates/potion_makers_mixtures_template.html'
       ],

function(Backbone, PotionMakersMixturesTemplate){
    var PotionMakersMixturesView = Backbone.View.extend({

      initialize : function(){
      },

      render: function() {
	var template = _.template(PotionMakersMixturesTemplate, {});
	$(this.el).html(template);	
	return this;
      }
  });

  return PotionMakersMixturesView;
});

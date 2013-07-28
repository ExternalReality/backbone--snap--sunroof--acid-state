define([ 'backbone'
       , 'text!/../templates/mixture.html'      
       ],
function(Backbone, MixtureTemplate){

  var MixtureView = Backbone.View.extend({
    
    events : { 'click #save-mixture-button'  : 'saveMixture'
             , 'click #clear-mixture-button' : 'clearMixture'
	     },

    initialize : function(mixture){
      this.mixture = mixture;
   },

    addReagent : function(reagent){
      if (this.mixture.containsReagent(reagent)){
	return;
      } else { 
	this.$("#mixture-reagents").append('<li>' + reagent.name() + '</li>');
	this.mixture.addReagent(reagent);
      };
    },

    saveMixture : function(){
      this.mixture.saveMixture();
    },

    clearMixture : function(){
      this.mixture.set("reagents", []); //= new Mixture();      
      this.$("#mixture-reagents").replaceWith('<ul id="mixture-reagents"></ul>');
    },

    render: function() {
      var template = _.template(MixtureTemplate,{});
      this.$el.html(template);
      this.setElement(template);
      
      return this;
    }

  });

  return MixtureView;
});

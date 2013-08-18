define([ 'backbone'
       , 'text!/../templates/soap.html'      
       ],
function(Backbone, SoapCreateionTemplate){

  var SoapCreationView = Backbone.View.extend({
    
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
	this.$("#soap-reagents").append('<li>' + reagent.name() + '</li>');
	this.mixture.addReagent(reagent);
      };
    },

    saveMixture : function(){
      this.mixture.saveMixture();
    },

    open : function() {
      this.clearMixture();
    },

    clearMixture : function(){
      this.setReagentsToNewArray();
      this.$("#soap-reagents").replaceWith('<ul id="soap-reagents"></ul>');
    },

    setReagentsToNewArray : function(){
      this.mixture.set("reagents", []);
    },

    render: function() {
      var template = _.template(SoapCreateionTemplate,{});
      this.$el.html(template);
      this.setElement(template);      
      return this;
    }
  });

  return SoapCreationView;
});

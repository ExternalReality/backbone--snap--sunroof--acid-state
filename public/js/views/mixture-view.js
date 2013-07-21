define([ 'backbone'
       , 'collections/mixture'
       , 'text!/../templates/mixture.html'      
       ],
function(Backbone, Mixture, MixtureTemplate){

  var MixtureView = Backbone.View.extend({
    
    events : { 'click #save-mixture-button' : 'saveMixture' },

    initialize : function(){
      this.mixture = new Mixture();
    },

    addReagent : function(reagent){
      this.$("#mixture-reagents").append('<li>' + reagent.name() + '</li>');
      this.mixture.addReagent(reagent);
    },

    saveMixture : function(){
      this.mixture.saveMixture();
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

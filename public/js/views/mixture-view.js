define([ 'backbone'
       , 'collections/mixture'
       , 'text!/../templates/mixture.html'      
       ],
function(Backbone, Mixture, MixtureTemplate){

  var MixtureView = Backbone.View.extend({

    initialize : function(){
      this.collection = new Mixture();
    },

    addReagent : function(reagent){
      this.$("#mixture-reagents").append('<li>' + reagent.name() + '</li>');
      this.collection.addReagent(reagent);
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

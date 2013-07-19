define([ 'backbone'
       , 'text!/../templates/mixture.html'      
       ],

function(Backbone, MixtureTemplate){

  var PotionBottleView = Backbone.View.extend({

    initialize : function(){
    },

    render: function() {
      var template = _.template(MixtureTemplate,{});
      this.$el.html(template);
      this.setElement(template);
      
      return this;
    }

  });

  return PotionBottleView;
});

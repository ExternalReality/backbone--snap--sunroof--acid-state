define([ 'backbone'
       , 'text!/../templates/potion-bottle.html'
       , 'jquery.ui'
       ],

function(Backbone, PotionBottleTemplate){

  var PotionBottleView = Backbone.View.extend({

    initialize : function(){
    },

    render: function() {
      var template = _.template(PotionBottleTemplate,{});
      this.$el.html(template);
      this.setElement(template);
      this.$el.droppable();
      return this;
    }

  });

  return PotionBottleView;
});

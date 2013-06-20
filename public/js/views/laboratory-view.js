define([ 'backbone'
       , 'views/reagent-list-view'
       , 'views/potion-bottle-view'
       , 'text!/../templates/laboratory.html'
       ],

function( Backbone
	, ReagentListView
	, PotionBottleView
	, LaboratoryTemplate
	){

  var LaboratoryView = Backbone.View.extend({

    render: function() {

      var template = _.template(LaboratoryTemplate, {});
      this.$el.html(template);
      this.setElement(template);

      var reagents = new ReagentListView().render().el;
      var potionBottle = new PotionBottleView().render().el;

      this.$('.reagents').replaceWith(reagents);
      this.$('.potion-bottle').replaceWith(potionBottle);

      return this;
    }

  });

  return LaboratoryView;

});

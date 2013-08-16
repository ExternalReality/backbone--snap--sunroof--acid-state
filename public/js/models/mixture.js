define([ 'backbone'
       , 'underscore'
       , 'models/reagent-model'
       ],

function( Backbone, _, ReagentModel ){

  var Mixture = Backbone.Model.extend({
    url: '/api/mixtures',
      
    initialize : function(mixtureData){
	this.set('reagents', mixtureData ? mixtureData.reagents : []);      
    },

    reagents : function(){
      return this.get('reagents');
    },

    addReagent : function (reagent){
      this.reagents().push(reagent);
    },

    saveMixture : function (){
      this.sync("update", this);
    },

    containsReagent : function (reagent){
      return _.contains(this.reagents(), reagent);      
    }

  });

  return Mixture;
});

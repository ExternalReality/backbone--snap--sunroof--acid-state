define([ 'backbone'
       , 'models/reagent-model'
       ],

function(Backbone, SunroofReagentModel){
  var Reagents = Backbone.Collection.extend({
    url: '/api/reagents',
    model: SunroofReagentModel
  });

  return Reagents;
});

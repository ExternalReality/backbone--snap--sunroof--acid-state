define([ 'backbone'
       , 'models/reagent-model'
       ],

function(Backbone, ReagentModel){
  var Reagents = Backbone.Collection.extend({
    url: '/api/reagents',
    model: ReagentModel
  });

  return Reagents;
});